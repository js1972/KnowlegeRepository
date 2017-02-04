package test;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.Collections;



class wikiItem implements Comparable<wikiItem>
{
	private int mFileIndex;
	private String mWholePath;
	
	public int getFileIndex()
	{
		return mFileIndex;
	}
	
	public wikiItem(String fullPath)
	{
		mWholePath = fullPath;
		mFileIndex = Integer.parseInt(mWholePath.substring(0, 3));
	}
	
	public void print()
	{
		System.out.println(mWholePath);
		System.out.println();
	}

	@Override
	public int compareTo(wikiItem o) {
		return mFileIndex - o.getFileIndex();
	}
}

public class Launcher 
{
	private String mConfigureFile;
	private String mFolderPath;
	private int mStartPrefix;
	ArrayList<wikiItem> mWikiList = new ArrayList<wikiItem>();
	
	public Launcher(String folder)
	{
		mConfigureFile = folder;
		readConfig();
	}
	
	private void readConfig()
	{
		try 
		{
			FileInputStream f = new FileInputStream(mConfigureFile);
			BufferedReader dr = new BufferedReader(new InputStreamReader(f));   
			
			mFolderPath = dr.readLine();
		    mStartPrefix = Integer.valueOf(dr.readLine());
		} 
		catch (IOException e) 
		{
		}
	}
	
	private String getFileID(File file)
	{
		return file.getName().substring(0,3);
	}
	
	private boolean shouldRecord(File file)
	{
		String num = file.getName().substring(0, 3);
		int number = -1;
		try
		{
			number = Integer.parseInt(num);
		}
		catch (java.lang.NumberFormatException e) 
		{
			return false;
		}
		if( number < mStartPrefix )
			return false;
		return true;
	}
	
	private void output()
	{
		Collections.sort(mWikiList);
		for( int i = 0; i < mWikiList.size(); i++)
			mWikiList.get(i).print();
	}
	
	private String getFormattedName(String name)
	{
		return name.substring(4, name.length() - 4);
	}
	private void collect(File file)
	{
		String path = getFileID(file) + ". [" + getFormattedName(file.getName()) + "|" + file.getAbsolutePath() + "]";
		wikiItem item = new wikiItem(path);
		mWikiList.add(item);
	}
	
	// 052. [ABAP Script Examples|\\cnctul000\Restricted\ACI_CRM\CR52_ABAP Script Examples.pdf]
	public void run()
	{
		File folder = new File(mFolderPath);
		File[] list = folder.listFiles();
		for( int i = 0; i < list.length; i++)
		{
			if(shouldRecord(list[i]))
				collect(list[i]);
		}
		output();
	}

	static public void main(String argv[]) throws IOException 
	{
		Launcher tool = new Launcher("C:\\temp\\1.txt");
		tool.run();
	}

}
	
	

	

