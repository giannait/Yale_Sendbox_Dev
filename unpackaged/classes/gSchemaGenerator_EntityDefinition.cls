/**
 * Created by gianrishandy on 5/3/2017.
 */

public with sharing class gSchemaGenerator_EntityDefinition {

    public String ApiName {set; get;}
    public String Label {set; get;}
    public List<gSchemaGenerator_FieldDefinition> FieldDefinitions {set; get;}

    public gSchemaGenerator_EntityDefinition(){}

    public gSchemaGenerator_EntityDefinition(String apiName, String label, List<gSchemaGenerator_FieldDefinition> fieldDefinitions){
        ApiName = apiName;
        Label = label;
        FieldDefinitions = fieldDefinitions;
    }
}