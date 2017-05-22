public class UserEntitiy {
	public Id id {set; get;}
	public String name {set; get;}
	public String type {set; get;}

	public UserEntitiy(Id id, String name, String type){
		this.id = id;
		this.name = name;
		this.type = type;
	}
}