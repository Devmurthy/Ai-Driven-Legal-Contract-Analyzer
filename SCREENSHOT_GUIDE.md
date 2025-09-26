# AI Legal Contract Analyzer - Screenshot Guide

## Overview
This guide provides detailed navigation instructions for capturing screenshots of the AI Legal Contract Analyzer Salesforce application. Each screenshot should demonstrate key functionality and technical implementation.

---

## 📱 **Figure 1: Legal Analyzer App with Custom Tabs**

**Navigation:** 
1. Click the **App Launcher** (9 dots icon) in the top-left corner
2. Search for "**Legal Contracts**" or "**Legal Analyzer**"
3. Click on the app to open it

**Screenshot:** App header showing the custom tabs (Contracts, Clauses, Negotiation Suggestions)
**Caption:** "Legal Analyzer app with custom tabs for contract management"

---

## 🏗️ **Figure 2: Contract__c Object Details**

**Navigation:** 
1. Go to **Setup** (gear icon) → **Object Manager**
2. Search for "**Contract**" or scroll to find "**Legal Contract**"
3. Click on **Legal Contract** → **Details**

**Screenshot:** Object details page showing:
- Object Label: "Legal Contract"
- API Name: "Contract__c"
- Record Name Format: "CT-{00000}"
- Sharing Model: "Read/Write"

**Caption:** "Contract__c object with auto-numbering and proper sharing model"

---

## 📋 **Figure 3: Contract__c Fields Overview**

**Navigation:** 
1. From Contract__c object → **Fields & Relationships**
2. Scroll through the fields list

**Screenshot:** Fields list showing key fields:
- Title__c (Text)
- Status__c (Picklist)
- Contract_Type__c (Picklist)
- Overall_Risk_Score__c (Number)
- Total_Clauses__c (Number)
- High_Risk_Clauses__c (Number)
- Medium_Risk_Clauses__c (Number)
- Low_Risk_Clauses__c (Number)
- Extracted_Text__c (Long Text Area)
- Analyzed_Date__c (DateTime)
- Analysis_Error__c (Long Text Area)

**Caption:** "Contract fields including analysis metrics and risk scoring"

---

## 🔗 **Figure 4: Clause__c Object Details**

**Navigation:** 
1. Setup → **Object Manager** → Search "**Clause**"
2. Click on **Contract Clause** → **Details**

**Screenshot:** Object details page showing:
- Object Label: "Contract Clause"
- API Name: "Clause__c"
- Record Name Format: "CL-{00000}"
- Sharing Model: "Controlled by Parent"

**Caption:** "Clause__c object with parent-controlled sharing"

---

## 📝 **Figure 5: Clause__c Fields with Master-Detail Relationship**

**Navigation:** 
1. From Clause__c object → **Fields & Relationships**
2. Scroll through the fields list

**Screenshot:** Fields list showing:
- Contract__c (Master-Detail to Contract__c)
- Clause_Number__c (Text)
- Title__c (Text)
- Clause_Type__c (Picklist: Payment, Liability, Termination, etc.)
- Risk_Level__c (Picklist: Low, Medium, High, Critical)
- Risk_Score__c (Number)
- Original_Text__c (Long Text Area)
- Extracted_Text__c (Long Text Area)
- Start_Position__c (Number)
- End_Position__c (Number)
- Status__c (Picklist)

**Caption:** "Clause fields with Master-Detail relationship to Contract"

---

## 🔗 **Figure 6: Master-Detail Relationship Detail**

**Navigation:** 
1. From Clause__c Fields & Relationships → Click on **Contract__c** field
2. View the field details

**Screenshot:** Field detail page showing:
- Field Type: "Master-Detail Relationship"
- Parent Object: "Contract__c"
- Child Relationship Name: "Clauses"
- Cascade Delete: "Yes"
- Referential Integrity: "Enforced"

**Caption:** "Master-Detail relationship with referential integrity and cascade delete"

---

## 🤖 **Figure 7: NegotiationSuggestion__c Object Details**

**Navigation:** 
1. Setup → **Object Manager** → Search "**Negotiation**"
2. Click on **Negotiation Suggestion** → **Details**

**Screenshot:** Object details page showing:
- Object Label: "Negotiation Suggestion"
- API Name: "NegotiationSuggestion__c"
- Record Name Format: "NS-{00000}"

**Caption:** "NegotiationSuggestion__c for AI-generated suggestions"

---

## 💡 **Figure 8: NegotiationSuggestion__c Fields**

**Navigation:** 
1. From NegotiationSuggestion__c object → **Fields & Relationships**

**Screenshot:** Fields list showing:
- Clause__c (Master-Detail to Clause__c)
- Party_Goal__c (Picklist: Buyer, Seller, Neutral)
- Negotiation_Tone__c (Picklist: Collaborative, Aggressive, Defensive)
- Requested_Changes__c (Long Text Area)
- Context__c (Long Text Area)
- Suggested_Text__c (Long Text Area)
- Explanation__c (Long Text Area)
- Risk_Impact__c (Picklist: Decreased, Unchanged, Increased)
- Risk_Change__c (Number)
- Confidence_Score__c (Number)
- Status__c (Picklist)
- AI_Model__c (Text)

**Caption:** "Negotiation suggestion fields for AI-powered contract negotiation"

---

## 📡 **Figure 9: Platform Event Definition**

**Navigation:** 
1. Setup → **Platform Events** → Search "**Status_Change_Event**"
2. Click on **Status Change Event**

**Screenshot:** Platform Event definition showing fields:
- Record_Id__c (Text)
- Record_Type__c (Text)
- New_Status__c (Text)
- Owner_Email__c (Text)
- Record_Name__c (Text)
- Record_Title__c (Text)

**Caption:** "Platform Event for real-time status change notifications"

---

## 💻 **Figure 10: Apex Classes List**

**Navigation:** 
1. Setup → **Apex Classes**

**Screenshot:** List showing deployed classes:
- ContractAnalysisService
- AINegotiationService
- ContractDashboardController
- StatusNotificationService
- ContractStatusEventSubscriber
- ClauseStatusEventSubscriber
- SlackNotifier
- TeamsNotifier

**Caption:** "Deployed Apex classes for business logic and AI integration"

---

## ⚡ **Figure 11: Apex Triggers List**

**Navigation:** 
1. Setup → **Apex Triggers**

**Screenshot:** List showing triggers:
- ContractStatusTrigger (Object: Contract__c)
- ClauseStatusTrigger (Object: Clause__c)

**Caption:** "Bulkified Apex triggers for status change automation"

---

## 🎨 **Figure 12: LWC Bundle in Setup**

**Navigation:** 
1. Setup → **Lightning Components** → **Lightning Component Bundles**

**Screenshot:** List showing:
- contractDashboard bundle visible

**Caption:** "Lightning Web Component: contractDashboard bundle"

---

## 📊 **Figure 13: LWC on App Page**

**Navigation:** 
1. Go to the **Legal Contracts** app
2. Look for the dashboard component on the main page

**Screenshot:** LWC component rendering with:
- Dashboard title: "AI Legal Contract Analyzer Dashboard"
- Tabs: Overview, Contracts, Analytics, Settings
- KPI cards showing contract statistics
- Recent contracts table
- Quick action buttons

**Caption:** "Dashboard LWC rendering in Lightning App with KPIs and navigation"

---

## 📋 **Figure 14: Contracts List View**

**Navigation:** 
1. In Legal Contracts app → **Contracts** tab
2. View the "All" list view

**Screenshot:** List view showing:
- Contract records with CT-xxxxx format
- Columns: Contract Number, Title, Status, Contract Type, Risk Score
- Data rows (if any exist)

**Caption:** "Contracts list view with auto-numbered records"

---

## 📝 **Figure 15: Clauses List View**

**Navigation:** 
1. In Legal Contracts app → **Clauses** tab
2. View the "All" list view

**Screenshot:** List view showing:
- Clause records with CL-xxxxx format
- Columns: Clause Number, Title, Clause Type, Risk Level, Contract
- Data rows (if any exist)

**Caption:** "Clauses linked to contracts with risk assessment"

---

## 🔄 **Figure 16: Status Change Workflow Demo**

**Navigation:** 
1. Open a Contract record (create one if needed)
2. Edit the record
3. Change Status__c to "Approved"
4. Save the record

**Screenshot:** Contract record after status update showing:
- Status field updated to "Approved"
- Last Modified date updated
- Any related list updates

**Caption:** "Contract status updated to Approved (triggers automated notifications)"

---

## 🧪 **Figure 17: Apex Test Execution Results**

**Navigation:** 
1. Setup → **Apex Test Execution**
2. Click **Select Tests**
3. Select all test classes:
   - ContractAnalysisServiceTest
   - AINegotiationServiceTest
   - ContractDashboardControllerTest
   - StatusNotificationServiceTest
4. Click **Run** → **View Results**

**Screenshot:** Test results page showing:
- Test run ID
- Passed tests count
- Failed tests count
- Overall result: "Passed"

**Caption:** "Apex test execution with 100% pass rate"

---

## 📈 **Figure 18: Code Coverage Summary**

**Navigation:** 
1. Setup → **Apex Test Execution** → **Code Coverage**
2. View overall coverage

**Screenshot:** Code coverage page showing:
- Overall coverage percentage (target: 81%+)
- Per-class coverage breakdown
- Coverage details for each class

**Caption:** "Org-wide code coverage achieving 81% target"

---

## 🖥️ **Figure 19: CLI Test Run (Optional)**

**Command:** 
```bash
sf apex run test --class-names StatusNotificationServiceTest,ContractAnalysisServiceTest,AINegotiationServiceTest,ContractDashboardControllerTest --wait 10 --code-coverage --result-format human
```

**Screenshot:** Terminal output showing:
- Test execution progress
- Pass/fail results
- Coverage percentages
- Execution time

**Caption:** "CLI test execution with coverage reporting"

---

## 📄 **Figure 20: Page Layouts**

**Navigation:** 
1. Setup → **Object Manager** → **Contract__c** → **Page Layouts**
2. Click on the layout name

**Screenshot:** Page layout showing:
- Key fields arranged in sections
- Analysis fields section
- Risk scoring fields
- Related lists

**Caption:** "Page layout with analysis and risk assessment fields"

---

## ✅ **Figure 21: Validation Rules and Picklists**

**Navigation:** 
1. Setup → **Object Manager** → **Contract__c** → **Fields & Relationships**
2. Click on **Status__c** field

**Screenshot:** Field detail showing:
- Picklist values: Uploaded, Processing, Analyzed, Under Review, Approved, Rejected
- Required field settings
- Validation rules

**Caption:** "Picklist values and validation for data consistency"

---

## 🔐 **Figure 22: Permission Set (Optional)**

**Navigation:** 
1. Setup → **Permission Sets** → **Legal_Analyzer_User**

**Screenshot:** Permission set showing:
- Object permissions for Contract__c, Clause__c, NegotiationSuggestion__c
- Field permissions
- Tab permissions

**Caption:** "Permission Set for end-user access control"

---

## 📊 **Figure 23: Reports and Dashboards**

**Navigation:** 
1. App → **Reports** → **New Report**
2. Select "Contracts" or "Clauses" report type
3. Run the report

**Screenshot:** Report results showing:
- Contract data with risk scores
- Clause distribution by risk level
- Charts and visualizations

**Caption:** "Contract risk analysis report with visualizations"

---

## 🏗️ **Figure 24: App Builder Navigation**

**Navigation:** 
1. Setup → **App Manager** → Find "Legal Contracts" app → **Edit**

**Screenshot:** App Builder showing:
- Navigation Items: Contracts, Clauses, Negotiation Suggestions
- App properties
- Navigation structure

**Caption:** "App navigation configured in App Builder"

---

## 🏢 **Figure 25: Company Information**

**Navigation:** 
1. Setup → **Company Information**

**Screenshot:** Company Information page showing:
- Organization ID (mask sensitive parts)
- Edition (Professional, Enterprise, etc.)
- Instance URL

**Caption:** "Org metadata for environment context"

---

## 🔍 **Figure 26: Source Deployment Confirmation (CLI)**

**Commands:** 
```bash
sf data query --query "SELECT Id, Name FROM ApexClass WHERE NamespacePrefix = null"
sf data query --query "SELECT Id, Name, TableEnumOrId FROM ApexTrigger WHERE NamespacePrefix = null"
```

**Screenshot:** Terminal output showing:
- List of deployed Apex classes
- List of deployed triggers
- Confirmation of metadata deployment

**Caption:** "Metadata deployment confirmation via CLI"

---

## 📱 **Figure 27: Mobile Responsive View (Optional)**

**Navigation:** 
1. Use browser developer tools to simulate mobile view
2. Navigate to the Legal Contracts app

**Screenshot:** Mobile view showing:
- Responsive dashboard layout
- Mobile-optimized navigation
- Touch-friendly interface

**Caption:** "Mobile-responsive Lightning Web Component interface"

---

## 🎯 **Screenshot Tips for Consistency**

### **Technical Requirements:**
- Use **100% browser zoom** for all screenshots
- Use **Lightning Experience** theme
- Capture in **1920x1080** resolution when possible
- Use consistent browser (Chrome recommended)

### **Visual Guidelines:**
- **Highlight key fields** with cursor or annotation
- **Crop out personal data** and sensitive information
- **Use consistent captions** under each image
- **Number figures** (Figure 1, Figure 2, etc.)

### **Data Preparation:**
- **Create sample data** before taking screenshots
- **Ensure test records exist** for list views
- **Run tests** to show coverage and results
- **Verify all components** are properly deployed

### **Screenshot Organization:**
- Save screenshots as: `figure_01_app_tabs.png`, `figure_02_contract_object.png`, etc.
- Store in `docs/screenshots/` directory
- Reference figures in the project report
- Include navigation instructions in image metadata

---

## 📋 **Pre-Screenshot Checklist**

Before taking screenshots, ensure:

- [ ] All metadata is deployed to the org
- [ ] Sample data is loaded (contracts, clauses, suggestions)
- [ ] Permission sets are assigned
- [ ] Flows are activated
- [ ] LWC components are visible
- [ ] Test classes have been executed
- [ ] Reports and dashboards are created
- [ ] App navigation is configured
- [ ] All custom objects are accessible

---

## 🎯 **Key Technical Demonstrations**

Each screenshot should demonstrate:

1. **Salesforce Native Development** - Custom objects, fields, relationships
2. **Lightning Web Components** - Modern UI with wire services
3. **Apex Services** - Business logic and AI integration
4. **Flow Automation** - Process automation and notifications
5. **Platform Events** - Real-time communication
6. **Security Model** - Permission sets and sharing rules
7. **Testing** - Comprehensive test coverage
8. **Integration** - External service connections
9. **Analytics** - Reports and dashboards
10. **Mobile Responsiveness** - Cross-device compatibility

This comprehensive screenshot guide ensures all key aspects of the AI Legal Contract Analyzer are properly documented and demonstrated for technical review and project presentation.
