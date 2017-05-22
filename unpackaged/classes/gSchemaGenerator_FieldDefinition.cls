/**
 * Created by gianrishandy on 5/3/2017.
 */

public with sharing class gSchemaGenerator_FieldDefinition {

    public String ApiName {set; get;}
    public String Label {set; get;}
    public Integer Length {set; get;}
    public String DataType {set; get;}
    public String Parent {set; get;}
    public String Child {set; get;}

    public gSchemaGenerator_FieldDefinition(){}

    public gSchemaGenerator_FieldDefinition(String apiName, String label, String length, String dataType, String parent, String child){
        ApiName = apiName;
        Label = label;
        Length = length;
        DataType = dataType;
        Parent = parent;
        Child = child;
    }
}