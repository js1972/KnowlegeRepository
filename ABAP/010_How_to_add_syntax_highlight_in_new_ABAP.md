# This wiki is written in aircraft from Frankfort to Beijing at 2016-12-4 20:00PM
## power left: 

* add entry in: "C:\MyApp\Sublime Text2\Data\Packages\ABAP\ABAP.tmLanguage"

* add entry in: "C:\MyApp\Sublime Text2\Data\Packages\ABAP\ABAP.sublime-completions"

## new keywords need to be added

* COND
* LET
* THEN
* THROW
* CONV
* BASE
* CAST
* FIND
* ASSERT
* RIGHT DELETING TRAILING
## new keywords for CDS view

* view
* #CHECK
* #SYSTEM_LANGUAGE - workaround, actually it is not a keyword - Jerry 2016-12-4 20:54PM from Germany to China - the highlight for word with # does not work! Neither for $projection.
* but sylangu can work 
* 2016-12-4 21:06PM solution found. Please refer to following xml configuration for example
```xml
		<dict>
			<key>comment</key>
			<string>--==[[ Jerry's CDS view related ]]==--</string>				
			<key>match</key>
			<string>(#CHECK)</string>
			<key>name</key>
			<string>constant.character.escape.abp</string>
		</dict>   
```


