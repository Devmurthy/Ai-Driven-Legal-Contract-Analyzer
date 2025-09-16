import { LightningElement, track, wire, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';
import getContractStats from '@salesforce/apex/ContractDashboardController.getContractStats';
import getContracts from '@salesforce/apex/ContractDashboardController.getContracts';

export default class ContractDashboard extends NavigationMixin(LightningElement) {
    @track contractStats = {};
    @track recentContracts = [];
    @track isLoading = true;
    @track selectedTab = 'overview';
    
    // Chart data for risk distribution
    @track riskChartData = [];
    
    // Quick action buttons
    quickActions = [
        { label: 'Upload Contract', icon: 'utility:upload', variant: 'brand' },
        { label: 'Search Contracts', icon: 'utility:search', variant: 'neutral' },
        { label: 'View Analytics', icon: 'utility:chart', variant: 'neutral' },
        { label: 'Settings', icon: 'utility:settings', variant: 'neutral' }
    ];

    connectedCallback() {
        this.loadDashboardData();
    }

    @wire(getContractStats)
    wiredContractStats({ error, data }) {
        if (data) {
            this.contractStats = data;
            this.recentContracts = data.recentContracts || [];
            this.processRiskChartData(data.riskDistribution || []);
            this.isLoading = false;
        } else if (error) {
            this.showToast('Error', 'Failed to load contract statistics', 'error');
            console.error('Error loading contract stats:', error);
        }
    }

    loadDashboardData() {
        this.isLoading = true;
        // Data will be loaded via wire service
    }

    processRiskChartData(riskDistribution) {
        this.riskChartData = riskDistribution.map(item => ({
            label: item.label,
            value: item.value
        }));
    }

    handleTabChange(event) {
        this.selectedTab = event.target.value;
    }

    handleQuickAction(event) {
        const action = event.currentTarget.dataset.action;
        switch(action) {
            case 'upload':
                this.navigateToUpload();
                break;
            case 'search':
                this.navigateToSearch();
                break;
            case 'analytics':
                this.navigateToAnalytics();
                break;
            case 'settings':
                this.navigateToSettings();
                break;
        }
    }

    navigateToUpload() {
        this.navigateToPage('Contract__c', 'New');
    }

    navigateToSearch() {
        this.navigateToPage('Contract__c', 'List');
    }

    navigateToAnalytics() {
        this.navigateToPage('Report', 'List');
    }

    navigateToSettings() {
        this.navigateToPage('Setup', 'Home');
    }

    navigateToPage(objectApiName, actionName) {
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: objectApiName,
                actionName: actionName
            }
        });
    }

    showToast(title, message, variant) {
        const evt = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant
        });
        this.dispatchEvent(evt);
    }

    // Computed properties
    get totalContracts() {
        return this.contractStats.totalContracts || 0;
    }

    get analyzedContracts() {
        return this.contractStats.analyzedContracts || 0;
    }

    get pendingContracts() {
        return this.contractStats.pendingContracts || 0;
    }

    get highRiskClauses() {
        return this.contractStats.highRiskClauses || 0;
    }

    get averageRiskScore() {
        return this.contractStats.averageRiskScore || 0;
    }

    get hasRecentContracts() {
        return this.recentContracts && this.recentContracts.length > 0;
    }

    get hasRiskData() {
        return this.riskChartData && this.riskChartData.length > 0;
    }
}