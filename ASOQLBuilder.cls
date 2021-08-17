/**
 * Created by Admin on 15.08.2021.
 */

public class ASOQLBuilder {

    public List<String> sobjectNames { get; set; }
    public List<String> selectedValue { get; set; }
    public List<String> objectFields { get; set; }
    public List<String> objectFieldTypes { get; set; }
    public List<SelectOption> objectFieldsOption { get; set; }
    public Boolean isObjectSelected { get; set; }

    public ASOQLBuilder() {
        sobjectNames = new List<String>();
        objectFields = new List<String>();
        selectedValue = new List<String>();
        objectFieldTypes = new List<String>();
        objectFieldsOption = new List<SelectOption>();
        isObjectSelected = false;
    }

    public void showFields() {
        clearFields();
        String objectName = ApexPages.currentPage().getParameters().get('objectName');
        setFields(objectName);
        isObjectSelected = true;
    }

    public void hideFields() {
        clearFields();
        isObjectSelected = false;
    }

    public void clearFields() {
        objectFieldTypes.clear();
        objectFields.clear();
        objectFieldsOption.clear();
    }

    public void init() {
        Map<String, Schema.SObjectType> globalSchema = Schema.getGlobalDescribe();
        for (String objName : globalSchema.keySet()) {
            if (
                    globalSchema.get(objName).getDescribe().isQueryable() &&
                            !globalSchema.get(objName).getDescribe().isCustomSetting() &&
                            globalSchema.get(objName).getDescribe().getRecordTypeInfos().size() > 0 &&
                            globalSchema.get(objName).getDescribe().isCreateable() &&
                            !objName.containsIgnoreCase('history') &&
                            !objName.containsIgnoreCase('tag') &&
                            !objName.containsIgnoreCase('share') &&
                            !objName.containsIgnoreCase('feed')
                    ) {
                sobjectNames.add(objName.substring(0, 1).toUpperCase() + objName.substring(1));
            }
        }
        sobjectNames.sort();
    }

    @RemoteAction
    public static List<SObject> getData(String query) {
        System.debug(query);
        List<sObject> records = Database.query(query);
        System.debug(records);
        return records;

    }

    public void setFields(String objectName) {
        Map<String, Schema.SObjectType> globalSchema = Schema.getGlobalDescribe();
        SObjectType objectType = globalSchema.get(objectName.toLowerCase());
        Map<String, SObjectField> fieldDescribes = objectType.getDescribe().fields.getMap();
        String fielRichdName;
        for (String fieldName : fieldDescribes.keySet()) {
            fielRichdName = fieldDescribes.get(fieldName).getDescribe().getName();
            objectFieldsOption.add(new SelectOption(fielRichdName, fielRichdName));
            objectFields.add(fielRichdName);
            objectFieldTypes.add(fieldDescribes.get(fieldName).getDescribe().getType().name());
        }

    }

}