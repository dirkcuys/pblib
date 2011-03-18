/// Almost a metaphor for a book with many pages, but the pages do not need to follow linearly

class PageHandler
{
	private var m_pageStack : Array<Page>;

	public function new()
	{
		m_pageStack = new Array<Page>();
	}

	/// Pushes a page onto the page stack and displays it
	public function showNextPage(page : Page)
	{
		if (m_pageStack.length > 0)
		{
			flash.Lib.current.removeChild(m_pageStack[m_pageStack.length-1]);
		}

		m_pageStack.push(page);
		flash.Lib.current.addChild(page);
		//trace("page added, stack.length=" + m_pageStack.length);
		//trace("stage.numchildren=" + flash.Lib.current.numChildren);
	}

	/// Pops a page from the page stack and removes it from the stage
	/// @return the page that was just removed
	public function showPreviousPage() : Page
	{
		/*if ( m_pageStack.length < 2 )
			return new null;*/

		var page = m_pageStack.pop();
		flash.Lib.current.removeChild(page);
		flash.Lib.current.addChild(m_pageStack[m_pageStack.length-1]);
		//trace("page removed, stack.length=" + m_pageStack.length);
		//trace("stage.numchildren=" + flash.Lib.current.numChildren);
		return page;
	}


}
