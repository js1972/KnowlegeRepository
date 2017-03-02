<?php 
header("content-type:text/html;charset=utf-8");


define("APPID","wxa1001125029145b8");
define("SECRET","fbe55077638655df000ef212f535156b");
class Weichat_menu_api{
	private $appid;
	private $secret;
	function __construct($appid,$secret)
	{
		$this->appid = $appid;
		$this->secret = $secret;
	}
	function get_access_token()
	{
		static $last_time = 1408851194;
		static $access_token = "";
		
		if(time()>($last_time + 7200))
		{
			$url = "https://api.weixin.qq.com/cgi-bin/token?grant_type=client_credential&appid={$this->appid}&secret={$this->secret}";
			$access_token_arr = $this->https_request($url);
			$last_time = time();
			$access_token = $access_token_arr['access_token'];
		}
		return $access_token;
	}
	
	//https request supporting http get and post
	function https_request($url,$data=null)
	{
		$ch = curl_init();
		curl_setopt($ch,CURLOPT_URL,$url);
		curl_setopt($ch,CURLOPT_RETURNTRANSFER,1);
		if($data)
		{
			curl_setopt($ch,CURLOPT_POST,1);//模拟Post
			curl_setopt($ch, CURLOPT_POSTFIELDS, $data);
		}
		$outopt = curl_exec($ch);
		curl_close($ch);
		$outopt = json_decode($outopt,true);
		return $outopt;
	}
	
	
	function menu_create($data)
	{
		$access_token = $this->get_access_token();
		$url = "https://api.weixin.qq.com/cgi-bin/menu/create?access_token={$access_token}";
		return $this->https_request($url,$data);
	}
	function menu_get()
	{
		$access_token = $this->get_access_token();
		$url = "https://api.weixin.qq.com/cgi-bin/menu/get?access_token={$access_token}";
		return $this->https_request($url);
	}
	function menu_delete()
	{
		$access_token = $this->get_access_token();
		$url = "https://api.weixin.qq.com/cgi-bin/menu/delete?access_token={$access_token}";
		return $this->https_request($url);
	}
	
}
//create menu
$menu_data = '{
     "button":[
     {	
          "type":"click",
          "name":"关于我们",
          "key":"V1001_TODAY_MUSIC"
      },
      {
           "name":"菜单",
           "sub_button":[
           {	
               "type":"view",
               "name":"我要搜索",
               "url":"http://www.soso.com/"
            },
            {
               "type":"view",
               "name":"看视频",
               "url":"http://v.qq.com/"
            },
            {
               "type":"click",
               "name":"赞一下我们",
               "key":"V1001_GOOD"
            }]
       }]
 }';

//test
$menu = new Weichat_menu_api(APPID,SECRET);

//print_r($menu->menu_delete());
print_r($menu->menu_create($menu_data));

?>