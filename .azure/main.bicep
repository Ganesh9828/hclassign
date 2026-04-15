targetScope = 'subscription'

// Parameters
param location string = 'eastus'
param environmentName string = 'prod'
param resourceGroupName string = 'rg-taskmgr-${uniqueString(subscription().id, location, environmentName)}'

// MySQL Parameters
param mysqlAdminLogin string = 'taskmgrAdmin'
@secure()
param mysqlAdminPassword string
param mysqlDatabaseName string = 'taskmgrdb'

// Variables to generate unique names
var uniqueSuffix = uniqueString(subscription().id, location, environmentName)
var resourcePrefix = 'tmgr'
var resourceToken = uniqueSuffix
var appInsightsName = 'ai${resourceToken}'
var keyVaultName = 'kv${resourceToken}'
var userManagedIdentityName = 'uami-${resourceToken}'
var logAnalyticsName = 'law${resourceToken}'
var appServicePlanName = 'asp-${resourceToken}'
var backendAppServiceName = 'app-backend-${resourceToken}'
var frontendAppServiceName = 'app-frontend-${resourceToken}'
var mySqlServerName = 'mysql-${resourceToken}'

// Create Resource Group
resource resourceGroup 'Microsoft.Resources/resourceGroups@2023-07-01' = {
  name: resourceGroupName
  location: location
}

// Create Log Analytics Workspace
resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2023-09-01' = {
  name: logAnalyticsName
  location: location
  parent: resourceGroup
  properties: {
    sku: {
      name: 'PerGB2018'
    }
    retentionInDays: 30
  }
}

// Create Application Insights
resource appInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: appInsightsName
  location: location
  parent: resourceGroup
  kind: 'web'
  properties: {
    Application_Type: 'web'
    WorkspaceResourceId: logAnalyticsWorkspace.id
    publicNetworkAccessForIngestion: 'Enabled'
    publicNetworkAccessForQuery: 'Enabled'
    RetentionInDays: 30
  }
}

// Create User-Assigned Managed Identity
resource userManagedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = {
  name: userManagedIdentityName
  location: location
  parent: resourceGroup
}

// Create Key Vault
resource keyVault 'Microsoft.KeyVault/vaults@2023-07-01' = {
  name: keyVaultName
  location: location
  parent: resourceGroup
  properties: {
    tenantId: subscription().tenantId
    sku: {
      family: 'A'
      name: 'standard'
    }
    accessPolicies: []
    publicNetworkAccess: 'Enabled'
    enableRbacAuthorization: true
    enableSoftDelete: true
    softDeleteRetentionInDays: 7
  }
}

// Create role assignment for managed identity to access Key Vault secrets
resource keyVaultRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(keyVault.id, userManagedIdentity.id, 'b86a8fe4-44ce-4948-aee5-eccb2c155cd7')
  scope: keyVault
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b86a8fe4-44ce-4948-aee5-eccb2c155cd7') // Key Vault Secrets Officer
    principalId: userManagedIdentity.properties.principalId
    principalType: 'ServicePrincipal'
  }
}

// Store MySQL password in Key Vault
resource mysqlPasswordSecret 'Microsoft.KeyVault/vaults/secrets@2023-07-01' = {
  name: 'mysqlPassword'
  parent: keyVault
  properties: {
    value: mysqlAdminPassword
  }
}

// Create App Service Plan
resource appServicePlan 'Microsoft.Web/serverfarms@2023-01-01' = {
  name: appServicePlanName
  location: location
  parent: resourceGroup
  sku: {
    name: 'B2'
    tier: 'Basic'
    size: 'B2'
    family: 'B'
    capacity: 1
  }
  kind: 'linux'
  properties: {
    reserved: true
  }
}

// Create Backend App Service
resource backendAppService 'Microsoft.Web/sites@2023-01-01' = {
  name: backendAppServiceName
  location: location
  parent: resourceGroup
  kind: 'app,linux'
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${userManagedIdentity.id}': {}
    }
  }
  properties: {
    serverFarmId: appServicePlan.id
    siteConfig: {
      linuxFxVersion: 'JAVA|17-java17'
      alwaysOn: true
      http20Enabled: true
      minTlsVersion: '1.2'
      scmMinTlsVersion: '1.0'
      numberOfWorkers: 1
      defaultDocuments: []
      appSettings: [
        {
          name: 'APPLICATIONINSIGHTS_CONNECTION_STRING'
          value: appInsights.properties.ConnectionString
        }
        {
          name: 'ApplicationInsightsAgent_EXTENSION_VERSION'
          value: '~3'
        }
        {
          name: 'XDT_MicrosoftApplicationInsights_Mode'
          value: 'recommended'
        }
        {
          name: 'SPRING_JPA_HIBERNATE_DDL_AUTO'
          value: 'update'
        }
        {
          name: 'SPRING_JPA_SHOW_SQL'
          value: 'false'
        }
      ]
      connectionStrings: []
      cors: {
        allowedOrigins: [
          'http://localhost:5173'
          'https://${frontendAppServiceName}.azurewebsites.net'
        ]
        supportCredentials: true
      }
    }
    httpsOnly: true
  }
}

// Create Frontend App Service
resource frontendAppService 'Microsoft.Web/sites@2023-01-01' = {
  name: frontendAppServiceName
  location: location
  parent: resourceGroup
  kind: 'app,linux'
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${userManagedIdentity.id}': {}
    }
  }
  properties: {
    serverFarmId: appServicePlan.id
    siteConfig: {
      linuxFxVersion: 'NODE|18-lts'
      alwaysOn: true
      http20Enabled: true
      minTlsVersion: '1.2'
      scmMinTlsVersion: '1.0'
      numberOfWorkers: 1
      appSettings: [
        {
          name: 'APPLICATIONINSIGHTS_CONNECTION_STRING'
          value: appInsights.properties.ConnectionString
        }
        {
          name: 'VITE_API_URL'
          value: 'https://${backendAppService.properties.defaultHostName}'
        }
      ]
    }
    httpsOnly: true
  }
}

// Diagnostic settings for Backend App Service
resource backendDiagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  name: 'diagnostic-settings-backend'
  scope: backendAppService
  properties: {
    workspaceId: logAnalyticsWorkspace.id
    metrics: [
      {
        category: 'AllMetrics'
        enabled: true
      }
    ]
    logs: [
      {
        categoryGroup: 'allLogs'
        enabled: true
      }
    ]
  }
}

// Diagnostic settings for Frontend App Service
resource frontendDiagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  name: 'diagnostic-settings-frontend'
  scope: frontendAppService
  properties: {
    workspaceId: logAnalyticsWorkspace.id
    metrics: [
      {
        category: 'AllMetrics'
        enabled: true
      }
    ]
    logs: [
      {
        categoryGroup: 'allLogs'
        enabled: true
      }
    ]
  }
}

// Create Azure Database for MySQL Flexible Server
resource mySqlServer 'Microsoft.DBforMySQL/flexibleServers@2023-06-01-preview' = {
  name: mySqlServerName
  location: location
  parent: resourceGroup
  sku: {
    name: 'Standard_B2s'
    tier: 'Burstable'
  }
  properties: {
    administratorLogin: mysqlAdminLogin
    administratorLoginPassword: mysqlAdminPassword
    storage: {
      storageSizeGB: 32
    }
    backup: {
      backupRetentionDays: 7
      geoRedundantBackup: 'Disabled'
    }
    highAvailability: {
      mode: 'Disabled'
    }
    network: {
      delegatedSubnetResourceId: ''
    }
    version: '8.0.32'
  }
}

// MySQL Firewall rule to allow Azure Services
resource mySqlFirewallRule 'Microsoft.DBforMySQL/flexibleServers/firewallRules@2023-06-01-preview' = {
  name: 'AllowAzureServices'
  parent: mySqlServer
  properties: {
    startIpAddress: '0.0.0.0'
    endIpAddress: '0.0.0.0'
  }
}

// Create MySQL Database
resource mySqlDatabase 'Microsoft.DBforMySQL/flexibleServers/databases@2023-06-01-preview' = {
  name: mysqlDatabaseName
  parent: mySqlServer
  properties: {
    charset: 'utf8mb4'
    collation: 'utf8mb4_unicode_ci'
  }
}

// Outputs
output backendAppServiceName string = backendAppService.name
output backendAppServiceUrl string = 'https://${backendAppService.properties.defaultHostName}'
output frontendAppServiceName string = frontendAppService.name
output frontendAppServiceUrl string = 'https://${frontendAppService.properties.defaultHostName}'
output mySqlServerName string = mySqlServer.name
output resourceGroupName string = resourceGroup.name
output mySqlConnectionString string = 'Server=${mySqlServer.properties.fullyQualifiedDomainName};Database=${mysqlDatabaseName};Uid=${mysqlAdminLogin}@${mySqlServer.name};Pwd=<password>;SSL=true;CharacterSet=utf8mb4;'
output userManagedIdentityId string = userManagedIdentity.id
output userManagedIdentityPrincipalId string = userManagedIdentity.properties.principalId
