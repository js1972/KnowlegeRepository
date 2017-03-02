<?php
use sinacloud\sae\Storage as Storage; //upload mp3 to sina cloud
// define your token
define ( "TOKEN", "bille" );
define ("BAIDU_TOKEN","24.229b04dcbe1338b22051faf6d8f5c3ef.2592000.1459386754.282335-7707083");
$wechatObj = new Weichat_base_api ();
if (isset ( $_GET ['echostr'] )) {
	$wechatObj->valid (); // 验证URL有效性，请原样返回echostr参数内容，则接入生效，成为开发者成功，否则接入失败。
} else {
	$wechatObj->responseMsg ();
}

class Weichat_base_api {
	public function valid() {
		$echoStr = $_GET ["echostr"];
		if ($this->checkSignature ()) {
			echo $echoStr;
			exit ();
		}
	}
	private function checkSignature() // 配置时验证URL有效性
	{
		// you must define TOKEN by yourself
		if (! defined ( "TOKEN" )) {
			throw new Exception ( 'TOKEN is not defined!' );
		}
		
		$signature = $_GET ["signature"]; // 微信加密签名，signature结合了开发者填写的token参数和请求中的timestamp参数、nonce参数。
		$timestamp = $_GET ["timestamp"]; // 时间戳
		$nonce = $_GET ["nonce"]; // 随机数
		
		$token = TOKEN;
		$tmpArr = array (
				$token,
				$timestamp,
				$nonce 
		);
		// use SORT_STRING rule
		sort ( $tmpArr, SORT_STRING );
		$tmpStr = implode ( $tmpArr );
		$tmpStr = sha1 ( $tmpStr );
		
		if ($tmpStr == $signature) {
			return true;
		} else {
			return false;
		}
	}
	
	public function responseMsg() {
		$postStr = $GLOBALS ["HTTP_RAW_POST_DATA"];
		
		if (! empty ( $postStr )) {
			$postObj = simplexml_load_string ( $postStr, 'SimpleXMLElement', LIBXML_NOCDATA );
			$fromUsername = $postObj->FromUserName;
			$toUsername = $postObj->ToUserName;
			$time = time ();
			switch ($postObj->MsgType) {
				case "text" :
					echo $this->receiveText($postObj);
					break;
				case "image" :
					echo $this->receiveImg($postObj);
					break;
				case "voice" :
					echo $this->receiveVoice($postObj);
					break;
				case "shortvideo" :
					$newsArr = array(
						array(
							"Title"=>"周哥测试1",
							"Description"=>"这是周哥测试的描述信息",
							"PicUrl"=>"https://ss0.baidu.com/6ONWsjip0QIZ8tyhnq/it/u=2026430319,4041659&fm=80",
							"Url"=>"http://news.163.com/16/0113/08/BD6RQDT500011229.html",
						),
						array(
							"Title"=>"周哥测试2",
							"Description"=>"这是周哥测试的描述信息 II",
							"PicUrl"=>"https://ss0.baidu.com/6ONWsjip0QIZ8tyhnq/it/u=3624483189,4086732657&fm=80",
							"Url"=>"http://cnews.chinadaily.com.cn/2016-01/13/content_23061286.htm",
						),
					);
					echo $this->replyNews($postObj,$newsArr);
					break;
				case "video" :
					echo $this->receiveVideo($postObj);
					break;
				case "location" :
					echo $this->receiveLocation($postObj);
					break;
				case "link" :
					echo $this->receiveLink($postObj);
					break;
				case "event":
					$this->receiveEvent($postObj);
					break;
			}
			 
		} else {
			echo "";
			exit ();
		}
	}
	private function receiveText($obj)
	{
		$content = $obj->Content;
		return $this->tuling_api($obj,$content);
	}
	
	private function receiveImg($obj)
	{
		//获取图片消息的内容
		$imageArr = array(
				"PicUrl"=>$obj->PicUrl,
				"MediaId"=>$obj->MediaId
				);
		return $this->replyimg($obj, $imageArr);
	}
	private function receiveLocation($obj){
		$locationArr = array(
				"Location_X"=>$obj->Location_X,
				"Location_Y"=>$obj->Location_Y,
				"Label"=>$obj->Label
		);
		return $this->replyLocation($obj, $locationArr);
	}
	
	private function receiveVoice($obj){
		if(isset($obj->Recognition))
		{
			$voice_content = $obj->Recognition;
			return $this->tuling_api($obj,$voice_content,"voice");
		}
		else
		{
			$voiceArr = array(
					"MediaId"=>$obj->MediaId,
					"Format"=>$obj->Format
			);
			return $this->replyVoice($obj, $voiceArr);
		}
	}
	private function receiveVideo($obj){
		$videoArr = array(
				"MediaId"=>$obj->MediaId,
				"ThumbMediaId"=>$obj->ThumbMediaId,
				"MsgId"=>$obj->MsgId
		);
		return $this->replyVideo($obj, $videoArr);
	}
	private function receiveLink($obj){
		$linkArr = array(
				"Title"=>$obj->Title,
				"Description"=>$obj->Description,
				"Url"=>$obj->Url
		);
		return $this->replyLink($obj, $linkArr);
	}
	
	private function receiveEvent($obj){
		switch ($obj->Event){
			case "subscribe":
				if(!empty($obj->EventKey)){
					//通过扫描带参数的二维码进行关注的逻辑
		
				}
				echo $this->replyText($obj,"你好，欢迎你关注我们的微信公众号码，给我们发送语音，调戏一下客服机器人吧，您可以说【成都天气】或者【明天从北京飞上海的航班】等！");
				break;
			case "unsubscribe":
				//write to data base about the unsubscribe
				break;
			case "SCAN":
				//已关注的情况下扫描带参数的二给码的逻辑
				break;
			case "LOCATION":
				break;
			case "CLICK":
				switch ($obj->EventKey){
					case "V1001_TODAY_MUSIC":
						echo $this->replyText($obj, "您点击的是[关于我们]");
						break;
					default:
						echo $this->replyText($obj, "谢谢您 的打赏！");
						break;
				}
				break;
		}
	}
	
	private function replyText($obj, $content)
	{
		$textTpl = "<xml>
                        <ToUserName><![CDATA[%s]]></ToUserName>
                        <FromUserName><![CDATA[%s]]></FromUserName>
                        <CreateTime>%s</CreateTime>
                        <MsgType><![CDATA[text]]></MsgType>
                        <Content><![CDATA[%s]]></Content>
                        <FuncFlag>0</FuncFlag>
                        </xml>";
		
		$resultStr = sprintf ( $textTpl, $obj->FromUserName, $obj->ToUserName, time(), $content );
		return $resultStr;
	}
	
	private function replyImg($obj, $imageArr){
		$replyXml = "<xml>
						<ToUserName><![CDATA[%s]]></ToUserName>
						<FromUserName><![CDATA[%s]]></FromUserName>
						<CreateTime>%s</CreateTime>
						<MsgType><![CDATA[image]]></MsgType>
						<Image>
						<MediaId><![CDATA[%s]]></MediaId>
						</Image>
					</xml>";
		return sprintf ( $replyXml, $obj->FromUserName, $obj->ToUserName, time(), $imageArr['MediaId'] );
	}
	private function replyLocation($obj, $locationArr){
		return $this->replyText($obj, $locationArr['Label']);
	}
	private function replyVoice($obj, $voiceArr){
		$replyXml = "<xml>
					<ToUserName><![CDATA[%s]]></ToUserName>
					<FromUserName><![CDATA[%s]]></FromUserName>
					<CreateTime>%s</CreateTime>
					<MsgType><![CDATA[voice]]></MsgType>
					<Voice>
					<MediaId><![CDATA[%s]]></MediaId>
					</Voice>
					</xml>";
		return sprintf ( $replyXml, $obj->FromUserName, $obj->ToUserName, time(), $voiceArr['MediaId'] );
	}
	private function replyVideo($obj, $videoArr){
		$replyXml = "<xml>
					<ToUserName><![CDATA[%s]]></ToUserName>
					<FromUserName><![CDATA[%s]]></FromUserName>
					<CreateTime>%s</CreateTime>
					<MsgType><![CDATA[video]]></MsgType>
					<Video>
					<MediaId><![CDATA[%s]]></MediaId>
					<Title><![CDATA[%s]]></Title>
					<Description><![CDATA[%s]]></Description>
					</Video> 
					</xml>";
		return sprintf ( $replyXml, $obj->FromUserName, $obj->ToUserName, time(), $videoArr['MediaId'], "这是视频标题", "这是视频具体的描述信息！" );		
	}
	private function replyMusic($obj, $musicArr){
		$replyXml = "<xml>
					<ToUserName><![CDATA[%s]]></ToUserName>
					<FromUserName><![CDATA[%s]]></FromUserName>
					<CreateTime>%s</CreateTime>
					<MsgType><![CDATA[music]]></MsgType>
					<Music>
					<Title><![CDATA[%s]]></Title>
					<Description><![CDATA[%s]]></Description>
					<MusicUrl><![CDATA[%s]]></MusicUrl>
					<HQMusicUrl><![CDATA[%s]]></HQMusicUrl>
					</Music>
					</xml>";
		return sprintf($replyXml,$obj->FromUserName,$obj->ToUserName,time(),$musicArr['Title'],$musicArr['Description'],$musicArr['MusicURL'],$musicArr['HQMusicUrl']);
	}
	private function replyLink($obj, $linkArr){
		return $this->replyText($obj, $linkArr['Description']);
	}
	private function replyNews($obj, $newsArr){
		$itemXml = "";
		if(is_array($newsArr))
		{
			foreach($newsArr as $item)
			{
				$itemStr = "<item>
							<Title><![CDATA[%s]]></Title>
							<Description><![CDATA[%s]]></Description>
							<PicUrl><![CDATA[%s]]></PicUrl>
							<Url><![CDATA[%s]]></Url>
							</item>";
				$itemXml .= sprintf ( $itemStr, $item['Title'], $item['Description'], $item['PicUrl'], $item['Url']);
			}
		}
		
		$replyXml = "<xml>
					<ToUserName><![CDATA[%s]]></ToUserName>
					<FromUserName><![CDATA[%s]]></FromUserName>
					<CreateTime>%s</CreateTime>
					<MsgType><![CDATA[news]]></MsgType>
					<ArticleCount>%s</ArticleCount>
					<Articles>
					{$itemXml}
					</Articles>
					</xml>";
		return sprintf ( $replyXml, $obj->FromUserName, $obj->ToUserName, time(),count($newsArr));
	}
	private function https_request($url,$data=null)
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
		$outoptArr = json_decode($outopt,true);
		if(is_array($outoptArr))
		{
			return $outoptArr;
		}
		else
		{
			return $outopt;
		}
	}
	private function get_baidu_voice($content)
	{
		$content=urlencode($content);
		$baidu_token=BAIDU_TOKEN;
		$baidu_voice_url="http://tsn.baidu.com/text2audio?tex={$content}&lan=zh&cuid=CTU50915170&ctp=1&tok={$baidu_token}";
		$voice=$this->https_request($baidu_voice_url);
		return $voice;
	}
	private function upload_media($content)
	{
	
		//Upload media to Sina Cloud to get access url
		$storage=new Storage();
		$mediaName=time().".mp3";
		$bucketName="mp3";
		$storage->putObject($content,$bucketName,$mediaName);
		$mp3Url=$storage->getUrl($bucketName,$mediaName);
		return $mp3Url;
		//currently not able to upload a network mp3 to weichat server
		/*
			$access_token=$this->get_access_token();
			$url="https://api.weixin.qq.com/cgi-bin/media/upload?access_token={$access_token}&type=voice";
			//file_put_contents("123.mp3","http://tsn.baidu.com/text2audio?tex=%E8%BF%99%E6%98%AF%E6%88%91%E6%83%B3%E8%A6%81%E8%AE%A9%E4%BD%A0%E8%AF%BB%E5%87%BA%E6%9D%A5%E7%9A%84%E8%AF%AD%E9%9F%B3%E4%BF%A1%E6%81%AF%EF%BC%8C%E4%BD%A0%E8%A7%89%E5%BE%97%E6%88%91%E8%AF%BB%E5%BE%97%E6%80%8E%E4%B9%88%E6%A0%B7%EF%BC%9F&lan=zh&cuid=CTU50915170&ctp=1&tok=24.4abf9d281640a29052eed0a77908d445.2592000.1456367301.282335-7707083");
			$post=array("filename"=>"@http://bille001-mp3.stor.sinaapp.com/1454081891.mp3");
			$mediaArr=$this->https_request($url,$post);
			return $mediaArr;*/
	}
	private function tuling_api($obj,$question,$type="text")
	{
		$question_en=urlencode($question);
		$tulingURL = "http://www.tuling123.com/openapi/api?key=de4ae9269c7438c33de5806562a35cac&info={$question_en}";
		$tulingResultArr=$this->https_request($tulingURL);
		if(isset($tulingResultArr['url']))
		{
			return $this->replyText($obj,$tulingResultArr['text']." ".$tulingResultArr['url']);
		}
		elseif(isset($tulingResultArr['list']))
		{
			$listArr = $tulingResultArr['list'];
			$itemObj = new ArrayObject();
			$i = 0;
			foreach($listArr as $list)
			{
				if(!empty($list['article']))
				{
					$description = $list['source'];// news
					$title = $list['article'];
				}
				else
				{
					$description = $list['info']; // cookbook
					$title = $list['name'];
				}
				$item = array(
						"Title"=>$title,
						"Description"=>$description,
						"PicUrl"=>$list['icon'],
						"Url"=>$list['detailurl'],
				);
				$i++;
				if ($i<10)
				{
					$itemObj->append($item);
				}
	
			}
			$itemArr = $itemObj->getArrayCopy();
			return $this->replyNews($obj,$itemArr);
		}
		else
		{
			if($type=="text")
			{
				return $this->replyText($obj,$tulingResultArr['text']);
			}
			else
			{
				$baidu_content = $this->get_baidu_voice($tulingResultArr['text']);
				$mp3Url=$this->upload_media($baidu_content);
				$musicArr=array(
						"Title"=>"Q:".$question,
						"Description"=>"A:".$tulingResultArr['text'],
						"MusicURL"=>$mp3Url,
						"HQMusicUrl"=>$mp3Url,
				);
				return $this->replyMusic($obj,$musicArr);
			}
				
		}
	}
}
?>