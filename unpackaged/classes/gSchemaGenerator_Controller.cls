/**
 * Created by gianrishandy on 5/4/2017.
 */

public with sharing class gSchemaGenerator_Controller extends gSchemaGenerator_ControllerBase{

    public String tableAPIName {set; get;}
    public List<SelectOption> selectOptions {set; get;}
    public List<gSchemaGenerator_FieldDefinition> fields {set; get;}

    private List<gSchemaGenerator_EntityDefinition> entities;

    public gSchemaGenerator_Controller(){
        entities = generateEntities();
        fields = new List<gSchemaGenerator_FieldDefinition>();
        selectOptions = new List<SelectOption>();
        selectOptions.add(new SelectOption('-- None --', '-- None --'));

        for(gSchemaGenerator_EntityDefinition entity : entities){
            selectOptions.add(new SelectOption(entity.ApiName, entity.ApiName));
        }
    }

    public void objectOnChange(){
        if(tableAPIName == '-- None --'){
            fields = new List<gSchemaGenerator_FieldDefinition>();
        }else{
            List<gSchemaGenerator_FieldDefinition> objectFields = null;

            for(gSchemaGenerator_EntityDefinition entity : entities){
                if(tableAPIName == entity.ApiName){
                    objectFields = entity.FieldDefinitions;
                    break;
                }
            }

            List<gSchemaGenerator_FieldDefinition> resultFields = new List<gSchemaGenerator_FieldDefinition>();

            for(gSchemaGenerator_FieldDefinition objectField : objectFields){
                if(objectField.DataType == 'Picklist'){
                    resultFields.add(getField(tableAPIName, objectField.ApiName));
                }else{
                    resultFields.add(objectField);
                }
            }

            fields = resultFields;
        }
    }

    private gSchemaGenerator_FieldDefinition getField(String objectName, String fieldName){
        gSchemaGenerator_FieldDefinition field = new gSchemaGenerator_FieldDefinition();

        String query = 'select QualifiedApiName, Label, Length, DataType, Metadata from FieldDefinition where EntityDefinition.QualifiedApiName = \'' + objectName + '\' and QualifiedApiName = \''+fieldName+'\'';
        query = query.replace(' ', '+');
        String result = generateMetadata(defaultAPIVersion, query);

        System.debug('result : ' + result);

        Map<String,Object> results = (Map<String, Object>)JSON.deserializeUntyped(result);
        List<Object> records = (List<Object>) results.get('records');

        if(records.size() > 0){
            Map<String, Object> record = (Map<String, Object>)records.get(0);

            field.ApiName = (String)record.get('QualifiedApiName');
            field.Label = (String)record.get('Label');
            field.Length = (Integer)record.get('Length');
            field.DataType = (String)record.get('DataType');

            if(field.DataType == 'Picklist'){
                field.DataType += ' [';

                Map<String, Object> metadata = (Map<String, Object>) record.get('Metadata');
                Map<String,Object> picklistMap = (Map<String, Object>)metadata.get('picklist');

                if(picklistMap != null){
                    List<Object> picklistValuesList = (List<Object>)picklistMap.get('picklistValues');
                    for(Integer j=0;j<picklistValuesList.size();j++){
                        Map<String, Object> value = (Map<String, Object>) picklistValuesList.get(j);

                        if(j == picklistValuesList.size() - 1){
                            field.DataType += (String)value.get('valueName');
                        }else{
                            field.DataType += (String)value.get('valueName') + ', ';
                        }
                    }
                }

                field.DataType += ']';
            }
        }

        return field;
    }

    private List<gSchemaGenerator_EntityDefinition> generateEntities(){
        List<gSchemaGenerator_EntityDefinition> entities = new List<gSchemaGenerator_EntityDefinition>();
        List<EntityDefinition> entityDefinitions = [SELECT QualifiedApiName,Label,(select QualifiedApiName,Label,Length,DataType from Fields) FROM EntityDefinition order by QualifiedApiName];

        for(EntityDefinition entityDefinition : entityDefinitions){
            List<FieldDefinition> fieldDefinitions = entityDefinition.Fields;

            gSchemaGenerator_EntityDefinition entity = new gSchemaGenerator_EntityDefinition();
            entity.ApiName = entityDefinition.QualifiedApiName;
            entity.Label = entityDefinition.Label;

            List<gSchemaGenerator_FieldDefinition> fields = new List<gSchemaGenerator_FieldDefinition>();

            for(FieldDefinition fieldDefinition : fieldDefinitions){
                gSchemaGenerator_FieldDefinition field = new gSchemaGenerator_FieldDefinition();
                field.ApiName = fieldDefinition.QualifiedApiName;
                field.Label = fieldDefinition.Label;
                field.Length = fieldDefinition.Length;

                if(field.ApiName == 'Id'){
                    field.DataType = 'Id';
                }else{
                    field.DataType = fieldDefinition.DataType;
                }

                fields.add(field);
            }

            if(fields.size() > 0){
                entity.FieldDefinitions = fields;
            }

            entities.add(entity);
        }

        return entities;
    }
}