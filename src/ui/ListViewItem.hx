package ui;

class ListViewItem extends TButton
{
	public var label(default,setLabel) : String;
	public var data(default,default) : Dynamic;

	public function new( ?label : String, ?data : Dynamic )
	{
		super(label);
		this.label = label;
		this.data = data;
		doubleClickEnabled = true;
	}

	private function setLabel( label : String ) : String
	{
		this.label = label;
		setText(label);
		return this.label;
	}
}
