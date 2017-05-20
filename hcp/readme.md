# Console Client
1. [help](https://help.sap.com/viewer/65de2977205c403bbc107264b8eccf4b/Cloud/en-US/76132306711e1014839a8273b0e91070.html)

# Supported Java API
1. [help](https://help.sap.com/viewer/65de2977205c403bbc107264b8eccf4b/Cloud/en-US/e836a95cbb571014b3c4c422837fcde4.html)
When you develop applications that run on SAP Cloud Platform, you can rely on certain Java EE standard APIs. These APIs are provided with the runtime of the platform. They are based on standards and are backward compatible as defined in the Java EE specifications. 

Cloud Foundry is an engaging open-source platform-as-a-service creating a buzz in the tech world

# User
1. D042416@gmail.com Sap12345
p1942400002trial
i042416trial
2. [limitation of trial account](https://help.sap.com/viewer/65de2977205c403bbc107264b8eccf4b/Cloud/en-US/e4986153bb571014a2ddc2fdd682ee90.html), for example One running Java application.

# Host
hanatrial.ondemand.com

# Url
1. [cockpit](https://account.hanatrial.ondemand.com/)
2. [How To Use A Servlet As Your Main Web Page](http://wiki.metawerx.net/wiki/HowToUseAServletAsYourMainWebPage)
3. install new software with url:  https://tools.hana.ondemand.com/neon
4. [My test application url](https://helloworldi042416trial.hanatrial.ondemand.com/JerryTest/)
After I changed it to Maven project on 2017-05-07, [new url](https://helloworldi042416trial.hanatrial.ondemand.com/jerrytest/)

# blogs

1. [Logging in HCP Cloud foundry with Java and Tomee using slf4j, logback, Jolokia](https://blogs.sap.com/2016/12/02/logging-in-hcp-cloud-foundry-with-java-and-tomee-using-slf4j-logback-jolokia/)

# work log
## 2017-05-01
956我为什么没办法publish 到cloud 上去？
1004可能我有个工具没装。新Eclipse还是需要配proxy
Possible hint: https://archive.sap.com/discussions/thread/3857381
finally it works: https://helloworldi042416trial.hanatrial.ondemand.com/JerryTest/
1518: I would like to achieve both servlet and html work. Is it really possible? I tried in local it is possible. Verified 1628, it is possible!
1613: 果然重启大法好。。。

## 2017-05-07
1. Sometimes after restart, I need to Maven->Update project or else the servlet could not be successfully instantiated again!
2. workaround does not work for resources in HCP?! Verified, workaround can still works if the web application is started in local server, but does not work in HCP.

## 2017-05-20

My Fiori application in HCP: https://flpportal-i042416trial.dispatcher.hanatrial.ondemand.com/sites?siteId=6af9e0d2-8b95-413c-9dc5-7d8b0c8b0ec1#jerrylist-Display

I am in Europe-Rot-Trial.

cf target -s dev

Error restarting application: BuildpackCompileFailed

cf logs jerry_list_wiesloch --recent
package.json is missing

npm install express - lots of file generated in my project folder :)

http://localhost:3000/ui5/ - can work!

cf api https://api.cf.us10.hana.ondemand.com

jerry-list-wiesloch.cfapps.us10.hana.ondemand.com

how the CF is clever enough to know that index.html should be executed??

https://jerrylist.cfapps.eu10.hana.ondemand.com/ can access now.
jerrylist.cfapps.eu10.hana.ondemand.com - 囧，要加https