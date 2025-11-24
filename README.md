# AI Legal Contract Analyzer — Salesforce
**Legal Contract Analyzer Project Phases**
**Demo Link: https://drive.google.com/file/d/1w5i1rgb9tVtk8nOL6j1nJtdiVN9K0_jK/view?usp=sharing**
**Project Documentation :https://drive.google.com/file/d/1AJ4tdirWVV08xuqko1xCjbY4UBtfkXBd/view?usp=sharing**
**Phase 1: Project Overview & Requirement Gathering**

Define project purpose and business value

Identify stakeholders and beneficiary users

Outline objectives such as automated clause extraction, risk analysis, AI negotiation, and compliance features

**Phase 2: Data Model Design**
Define custom Salesforce objects: Contract, Clause, NegotiationSuggestion

Establish master-detail relationships and lookups

Configure validation rules and picklists for statuses, risk levels, clause types

**Phase 3: Business Logic Implementation**

Develop Apex classes and services: ContractAnalysisService, AINegotiationService, StatusNotificationService

Implement triggers: ContractStatusTrigger, ClauseStatusTrigger

Automate status updates, risk scoring, AI negotiation suggestions generation

**Phase 4: User Interface & Lightning Web Components (LWC)**

Design and develop LWCs such as contractDashboard to display KPIs and risk charts

Create page layouts and tabs for Contracts, Clauses, Suggestions

Provide a rich, interactive experience for users

**Phase 5: Testing & Validation**

Write comprehensive Apex test classes covering services, triggers, and controllers

Perform UI integration testing (LWC wiring with Apex)

Achieve high org-wide Apex test coverage (81%+)

**Phase 6: Automation & Notifications**

Configure platform events (StatusChangeEvent) for real-time notifications

Develop email templates for status change alerts and negotiation messages

Design record-triggered flows for notifying stakeholders optionally

**Phase 7: Reporting & Dashboards**

Create reports on contract risks, clause distributions, and negotiation statuses

Build dashboards for legal analytics and management overview

**Phase 8: Deployment & Documentation**

Prepare change sets or SFDX deployments

Document architecture, data model, business logic, and user guides

**Phase 9: Future Enhancements Planning**

Plan advanced AI integrations for natural language processing and risk scoring

Consider batch or queueable Apex for large-scale processing

Enhance dashboards with deeper analytics and trend insights

This phased approach covers the end-to-end project lifecycle from requirements to deployment and ongoing improvement for the legal contract analyzer system on Salesforce. Let me know if more details on any phase are needed.

## ADDED: Flows, Platform Events, Email Templates, and Apex Subscribers

### Deploy (Salesforce DX)

```bash
sfdx force:auth:web:login -a legal-analyzer
sfdx force:source:deploy -u legal-analyzer -p force-app/main/default/objects/ContractStatusEvent__e
sfdx force:source:deploy -u legal-analyzer -p force-app/main/default/objects/ClauseStatusEvent__e
sfdx force:source:deploy -u legal-analyzer -p force-app/main/default/email/ContractStatusChange
sfdx force:source:deploy -u legal-analyzer -p force-app/main/default/email/ClauseStatusChange
sfdx force:source:deploy -u legal-analyzer -p force-app/main/default/classes/ContractStatusEventSubscriber.cls
sfdx force:source:deploy -u legal-analyzer -p force-app/main/default/classes/ClauseStatusEventSubscriber.cls
sfdx force:source:deploy -u legal-analyzer -p force-app/main/default/flows/Contract_Status_Change.flow-meta.xml
sfdx force:source:deploy -u legal-analyzer -p force-app/main/default/flows/Clause_Status_Change.flow-meta.xml

# ADDED: Email Alerts (Workflow) and Reports/Dashboard
sfdx force:source:deploy -u legal-analyzer -p force-app/main/default/workflows/Contract__c.workflow-meta.xml
sfdx force:source:deploy -u legal-analyzer -p force-app/main/default/workflows/Clause__c.workflow-meta.xml
sfdx force:source:deploy -u legal-analyzer -p force-app/main/default/reports/Contracts
sfdx force:source:deploy -u legal-analyzer -p force-app/main/default/reports/Clauses
sfdx force:source:deploy -u legal-analyzer -p force-app/main/default/dashboards/Legal_Analyzer_Dashboard.dashboard-meta.xml
```

### Validate

1. Change a `Contract__c.Status__c` and `Clause__c.Status__c` value; confirm emails (sample templates) and debug logs for event subscribers.
2. In Setup → Flows, confirm both flows are Active.
3. Check Debug Logs to see `ContractStatusEvent__e` and `ClauseStatusEvent__e` messages from subscriber classes.
4. Open Reports: Contracts by Status and Clauses by Status; confirm data is visible.
5. Open Dashboard: Legal Analyzer Dashboard; confirm both charts render.
6. Email Alerts: confirm the flows reference `ContractStatusChange_Alert` and `ClauseStatusChange_Alert` (defined in Workflow metadata).
7. Permission Set assignment: run `./data/assign-permset.sh -u legal-analyzer -t <user@domain.com>` and login-as target user to verify access to objects and reports.

## ADDED: Validation & Demo

### One-command validation
```bash
chmod +x scripts/validate-deployment.sh data/load-sample-data.sh data/assign-permset.sh
scripts/validate-deployment.sh legal-analyzer
```

What it does:
- Deploys all metadata via `manifest/package.xml`.
- Assigns `Legal_Analyzer_User` permission set.
- Loads sample data (3 Contracts, 5 Clauses).
- Confirms Flows are Active via SOQL on `FlowDefinitionView`.
- Verifies Reports exist.
- Runs Apex tests with coverage.

### Manual checklist (post-deploy)
- Flows Active: Contract_Status_Change, Clause_Status_Change
- Permission Set assigned: Legal_Analyzer_User
- Sample Data loaded: Contracts & Clauses visible
- Emails/Events: status changes send emails and log subscriber debug
- Reports visible: Contracts by Status, Clauses by Status
- Dashboard renders: Legal Analyzer Dashboard (two charts)

## ADDED: CI/CD (GitHub Actions)

Create a GitHub Secret `SFDX_AUTH_URL` containing your auth URL (`sfdx auth:web:login --setdefaultusername --setalias ci` then `sfdx auth:sfdxurl:store -f sfdxAuthUrl.txt ...`). Add the URL contents to the secret. The workflow is defined in:

- ADDED: `.github/workflows/salesforce-ci.yml`

What it does:
- Installs Salesforce CLI
- Authenticates using `SFDX_AUTH_URL`
- Runs check-only deploy against `manifest/package.xml`
- Executes Apex tests and enforces 75% org-wide coverage

### Lightning App Page
- ADDED: `force-app/main/default/flexipages/Legal_Analyzer_App.flexipage-meta.xml`
- After deployment, add the page to your app navigation and capture screenshots:
  - Recent Contracts & Clauses
  - Report charts and Dashboard component

## UPDATED: Installation
Package install (once published):
```
https://login.salesforce.com/packaging/installPackage.apexp?p0=04t000000000000AAA
```

## ADDED: Scratch Org Demo
```bash
chmod +x scripts/setup-scratch-org.sh
scripts/setup-scratch-org.sh <dev-hub-alias> legal-analyzer-scratch
```

## UPDATED: Changelog & License
- See `CHANGELOG.md` for release notes
- Licensed under MIT (`LICENSE`)

## UPDATED: Screenshots
Repository: https://github.com/Devmurthy/Ai-Driven-Legal-Contract-Analyzer.git

Place real screenshots into `docs/screenshots/` (placeholders provided):

![Flow](docs/screenshots/flow.png)
![Dashboard](docs/screenshots/dashboard.png)
![App Page](docs/screenshots/app_page.png)

### Contributing
- Fork the repo on GitHub: https://github.com/Devmurthy/Ai-Driven-Legal-Contract-Analyzer.git
- Clone your fork:
```bash
git clone https://github.com/<your-username>/Ai-Driven-Legal-Contract-Analyzer.git
cd Ai-Driven-Legal-Contract-Analyzer
```
- Create a feature branch, commit, and open a PR.

## ADDED: Integrations (Optional)
- Slack: configure a Slack Incoming Webhook and update `SlackNotifier.cls` WEBHOOK_URL. Example:
```apex
SlackNotifier.sendMessage('Contract Approved: ' + someContractId);
```
- Microsoft Teams: configure a Teams Incoming Webhook and update `TeamsNotifier.cls` WEBHOOK_URL. Example:
```apex
TeamsNotifier.sendMessage('Clause Rejected: ' + someClauseId);
```


# AI Legal Contract Analyzer & Negotiator - Salesforce Implementation

A comprehensive Salesforce-native application that leverages AI to analyze legal contracts, extract clauses, assess risks, and provide intelligent negotiation suggestions. Built entirely within the Salesforce platform using Lightning Web Components, Apex, and Flow automation.

## 🚀 Features

### Core Features
- **Contract Upload & Processing**: Upload PDF/DOCX contracts with automatic text extraction
- **AI-Powered Clause Extraction**: Automated detection and classification of legal clauses
- **Risk Assessment**: Intelligent risk scoring with color-coded highlighting
- **Negotiation Assistant**: AI-powered contract negotiation suggestions
- **Dashboard Analytics**: Comprehensive dashboard with KPIs and risk summaries
- **Role-Based Access**: Multi-role authentication with appropriate permissions
- **Automated Workflows**: Flow-based automation for contract processing

### Technical Features
- **Salesforce Native**: Built entirely within Salesforce using standard and custom objects
- **Lightning Web Components**: Modern, responsive UI components
- **Apex Services**: Robust business logic and AI integration
- **Flow Automation**: Automated contract processing workflows
- **Custom Objects**: Comprehensive data model for contracts, clauses, and suggestions
- **Platform Events**: Real-time notifications and updates
- **External Services**: Integration points for AI/ML services

## 📋 Prerequisites

- Salesforce org with appropriate permissions
- System Administrator access for deployment
- Salesforce CLI (sfdx) for development
- VS Code with Salesforce extensions

## 🛠️ Installation & Setup

### 1. Clone the Repository
```bash
git clone <repository-url>
cd legal-analyzer
```

### 2. Authenticate with Salesforce
```bash
sfdx auth:web:login -d -a mydevorg
```

### 3. Deploy to Salesforce
```bash
# Deploy all metadata
sfdx force:source:deploy -p force-app/main/default

# Or deploy specific components
sfdx force:source:deploy -m ApexClass:ContractAnalysisService
sfdx force:source:deploy -m LightningComponentBundle:contractDashboard
```

### 4. Assign Permissions
1. Go to Setup → Users → Permission Sets
2. Create or modify permission sets to include:
   - Read/Write access to Contract__c, Clause__c, NegotiationSuggestion__c
   - Access to Lightning Web Components
   - Access to Flows

### 5. Configure Custom Objects
1. Go to Setup → Object Manager
2. Verify all custom objects are deployed:
   - Legal Contract (Contract__c)
   - Contract Clause (Clause__c)
   - Negotiation Suggestion (NegotiationSuggestion__c)

## 🏗️ Architecture

### Data Model
```
Contract__c (Master)
├── Title, Description, Contract Type
├── File Information (Name, Size, Type)
├── Analysis Results (Risk Score, Clauses Count)
├── Status and Dates
└── Relationships to Users

Clause__c (Child of Contract__c)
├── Clause Details (Number, Title, Type)
├── Text Content (Original, Extracted)
├── Risk Analysis (Level, Score, Factors)
├── Review Status and Notes
└── Position Information

NegotiationSuggestion__c (Child of Clause__c)
├── Negotiation Parameters (Goal, Tone)
├── AI Suggestions (Text, Explanation)
├── Risk Impact Analysis
├── Confidence Scoring
└── Status and Processing Info
```

### Component Architecture
```
Lightning Web Components
├── contractDashboard (Main dashboard)
├── contractUpload (File upload component)
├── clauseAnalysis (Clause review component)
├── negotiationAssistant (AI negotiation UI)
└── analyticsCharts (Data visualization)

Apex Services
├── ContractAnalysisService (Core analysis logic)
├── AINegotiationService (AI integration)
├── ContractDashboardController (Dashboard data)
└── FileProcessingService (Document handling)

Flow Automation
├── Contract_Analysis_Flow (Processing workflow)
├── ContractNotificationFlow (Notifications)
└── RiskAssessmentFlow (Risk calculation)
```

## 🎯 Usage

### 1. Contract Upload
1. Navigate to the Legal Contracts tab
2. Click "New" to create a contract
3. Fill in contract metadata:
   - Title and Description
   - Contract Type
   - Parties involved
   - Effective and Expiration dates
4. Upload the contract file (PDF/DOCX)
5. Save the record

### 2. Automated Analysis
- The Contract Analysis Flow automatically triggers when a contract is uploaded
- Status changes from "Uploaded" → "Processing" → "Analyzed"
- AI extracts clauses and calculates risk scores
- Users receive notifications when analysis is complete

### 3. Clause Review
1. Navigate to the analyzed contract
2. View extracted clauses in the related list
3. Review risk levels and recommendations
4. Click on individual clauses for detailed analysis
5. Update clause status and add review notes

### 4. AI Negotiation
1. Select a clause that needs revision
2. Click "Request Negotiation Suggestion"
3. Configure parameters:
   - Party Goal (Buyer/Seller/Neutral)
   - Negotiation Tone (Collaborative/Aggressive/Defensive)
   - Requested Changes
   - Additional Context
4. AI generates suggestion with explanation
5. Accept, reject, or modify the suggestion

### 5. Dashboard Analytics
1. Access the Contract Dashboard
2. View key metrics:
   - Total contracts and analysis status
   - Risk distribution and trends
   - Recent activity and performance
3. Use quick actions for common tasks
4. Navigate between different views

## 🔧 Configuration

### Custom Settings
Create custom settings for configuration:

1. **AI_Configuration__c**:
   - OpenAI_API_Key__c
   - Default_Model__c
   - Confidence_Threshold__c
   - Risk_Thresholds__c

2. **Contract_Settings__c**:
   - Max_File_Size__c
   - Allowed_File_Types__c
   - Auto_Assignment_Rules__c
   - Notification_Templates__c

### External Service Integration
Configure external services in Setup → External Services:

1. **OpenAI Integration**:
   - Endpoint: https://api.openai.com/v1/chat/completions
   - Authentication: API Key
   - Rate Limiting: Configure appropriate limits

2. **Document Processing Service**:
   - OCR Service endpoint
   - File conversion service
   - Text extraction service

## 🧪 Testing

### Unit Tests
```bash
# Run all tests
sfdx force:apex:test:run -c -r human

# Run specific test class
sfdx force:apex:test:run -n ContractAnalysisServiceTest -r human
```

### Test Classes Included
- `ContractAnalysisServiceTest`
- `AINegotiationServiceTest`
- `ContractDashboardControllerTest`

### Test Data
Create test data using:
```apex
// Example test data creation
Contract__c testContract = new Contract__c(
    Title__c = 'Test Service Agreement',
    Contract_Type__c = 'Service Agreement',
    Status__c = 'Uploaded'
);
insert testContract;
```

## 📊 Monitoring & Analytics

### Custom Reports
Create reports for:
- Contract analysis performance
- Risk distribution trends
- Negotiation success rates
- User activity and engagement

### Dashboards
- Executive dashboard with high-level metrics
- Operational dashboard for daily management
- Risk monitoring dashboard for compliance

### Platform Events
Monitor platform events for:
- Contract analysis completion
- High-risk clause detection
- Negotiation suggestion generation
- System errors and exceptions

## 🔒 Security & Compliance

### Data Security
- Field-level security on sensitive data
- Sharing rules for contract visibility
- Encryption for file attachments
- Audit trail for all changes

### Compliance Features
- Complete audit logging
- Data retention policies
- GDPR compliance tools
- SOX compliance reporting

### User Permissions
- Role-based access control
- Permission sets for different user types
- Field-level security
- Object-level permissions

## 🚀 Deployment

### Production Deployment
```bash
# Validate deployment
sfdx force:source:deploy -p force-app/main/default -l RunSpecifiedTests -t ContractAnalysisServiceTest

# Deploy to production
sfdx force:source:deploy -p force-app/main/default -u production
```

### Change Sets
1. Create change set in source org
2. Add required components
3. Upload and deploy to target org
4. Validate deployment

### CI/CD Pipeline
```yaml
# .github/workflows/salesforce-ci.yml
name: Salesforce CI/CD
on: [push, pull_request]
jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: sfdx-actions/setup-sfdx@v1
      - run: sfdx force:source:deploy -p force-app/main/default
```

## 🔮 Future Enhancements

### Phase 1 (Current)
- ✅ Core contract analysis features
- ✅ AI-powered clause extraction
- ✅ Risk assessment and scoring
- ✅ Basic negotiation suggestions

### Phase 2 (Planned)
- 🔄 Advanced AI models integration
- 🔄 Real-time collaboration features
- 🔄 Advanced analytics and reporting
- 🔄 Mobile application

### Phase 3 (Future)
- 📋 Blockchain integration for contract verification
- 📋 Advanced compliance checking
- 📋 Multi-language support
- 📋 Enterprise SSO integration


**Built with ❤️ for legal professionals using Salesforce**

This implementation provides a complete, production-ready AI Legal Contract Analyzer built entirely within the Salesforce platform, demonstrating advanced use of Lightning Web Components, Apex services, Flow automation, and custom object design.
