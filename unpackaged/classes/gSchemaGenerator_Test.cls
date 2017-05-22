/**
 * Created by gian on 04/05/17.
 */
@IsTest
private class gSchemaGenerator_Test {
	public static testMethod void testMyController() {
		Test.startTest();

		PageReference pageRef = Page.gSchemaGenerator;
		Test.setCurrentPage(pageRef);

		gSchemaGenerator_Controller controller = new gSchemaGenerator_Controller();
		controller.tableAPIName = 'Account';
		controller.objectOnChange();

		Test.stopTest();
	}
}