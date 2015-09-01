package 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.events.KeyboardEvent;
	import flash.media.Sound;
	import flash.geom.ColorTransform;
	import fl.motion.easing.Back;
	import flash.events.MouseEvent;
	import fl.motion.Color;
	import fl.motion.easing.Linear;
	import flash.geom.ColorTransform;
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flashx.textLayout.events.ScrollEvent;
	
	public class gravityDodgeAs extends MovieClip
	{
		public function gravityDodgeAs()
		{
/*
-Variables
-On load
-Event Listeners
	-Enter Frame (gLoop)
	-Key Down(downkey)
	-Key Up(upkey)
	-XML(processXML)
-Functions
	-healthBar
	-movePlayer
	-spawnBubs
	-moveBubs
	-hitBubs
	-changeBubs
	-refreshTxt
	-timers
	-endGame
	-restart
	-explode(by, bx)
	-bubRemove(i)
*/
			//variables
			var myColorTransform = new ColorTransform();//defines the color transform
			var myLoader:URLLoader = new URLLoader();
			var myXML:XML;
			var music:Sound = new nujabes();//plays "Ordinary Joe" by Nujabes
			var now:Date = new Date();
			var startTime:Number = now.getTime();
			var curTime:Number = now.getTime();
			//v All three run parellel, make sure to splice them all at the same time v
			var bubArray:Array = new Array();//holds all the bubbles
			var bxArray:Array = new Array();//holds bubbles xspeed
			var byArray:Array = new Array();//holds bubbles xspeed
			//all simularly named to ease copy and paste edit time	
			var exArray:Array = new Array();//holds the exploding bubbles
			
			var nGrav:Boolean = false;//is there gravity pulling north?
			var eGrav:Boolean = false;
			var sGrav:Boolean = false;
			var wGrav:Boolean = false;
			
			var spawnRate:Number = 8;//alters how many ticks inbetween running spawnBubs
			var tickClock:Number = 0;//place holder counter
			var spawnSide:Number = 1;//1 for north, 2 for east ect
			var lives:Number = 5;//start with 5 lives, lose when hitting exploding bubble or evil bubble
			var score:Number = 0;//amount of bubbles absorbed
			var hscore:Number = 0;//saves highscore in ram, wont save after program restart
			var time:Number = 0;//current time since last restart
			var htime:Number = 0;//highest time achived
//onload
			var p:p1 = new p1();//spawns player
			p.x = 275;
			p.y = 200;
			addChild(p);
//text		tells user to click i for info, disapears after 3 seconds
			var infoTxt:TextField = new TextField();
			infoTxt.x = 10;
			infoTxt.y = 380;
			infoTxt.text = "i = info";
			addChild(infoTxt);
			
			var scoreTxt:TextField = new TextField();//holds score(# of bubA's absorbed)
			scoreTxt.x = 525;
			scoreTxt.y = 10;
			scoreTxt.text = String(score);
			addChild(scoreTxt);
			var hscoreTxt:TextField = new TextField();//highest amount achived
			hscoreTxt.x = 490;
			hscoreTxt.y = 10;//we don't add it onload because player has no highscore yet
			var sf:TextFormat = new TextFormat();
			sf.bold = true;//bolding format used for both time and score
			scoreTxt.setTextFormat(sf);
			
			var timeTxt:TextField = new TextField();//current time since last restart
			timeTxt.x = 525;
			timeTxt.y = 380;
			timeTxt.text = String(curTime - startTime);
			addChild(timeTxt);
			var htimeTxt:TextField = new TextField();//highest time
			htimeTxt.x = 490;
			htimeTxt.y = 380;
			
			var instTxt:TextField = new TextField();//xml textfield/instructions
			instTxt.x = 5;
			instTxt.y = 30;
			instTxt.width = 155;//this and below needed to fit it all onstage
			instTxt.multiline = true;
			instTxt.wordWrap = true;
			var conTxt:TextField = new TextField();//control(l)s textfield
			conTxt.x = 5;
			conTxt.y = 300;
			conTxt.multiline = true;
			conTxt.wordWrap = true;
			//draws healthbar
			var hBar:bar = new bar();//bar around filler
			hBar.x = 51;
			hBar.y = 13.5;
			addChild(hBar);
			var filler:fill = new fill();//red filler inside bar
			filler.x = 51;
			filler.y = 13.5;
			addChild(filler);
			
			myLoader.load(new URLRequest("info.xml"));
			//loads xml
			//<xml>
			//<howtoplay>When two bubbles hit, they explode. Don't touch the explosion or you'll lose health! When a bubble hits an explosion it will super charge it, these will also damage you.</howtoplay>
			//<controlls>i = instructions            r = restart           wasd or arrow keys to move</controlls>
			//</xml>
			music.play();//plays song
//event listeners
			addEventListener(Event.ENTER_FRAME, gLoop);
			function gLoop(e:Event):void
			{//holds game loop
				healthBar();//keeps track of lives, changes filler accordingly
				movePlayer();//moves player, stops them from escaping stage
				tickClock++;//constantly counts up once a tick
				if (tickClock > spawnRate)//lets you control how many ticks inbetween each exicution
				{
					spawnBubs();//spawns bubArray's
					tickClock = 0;//resets counter
				}
				moveBubs();//moves bubbles
				hitBubs();//hithoxes and removing bubs
				changeBubs();//changes normal bubbles to red evil ones
				refreshTxt();//preforms acrobatics whist on fire
				timers();
				if (lives <= 0) endGame();//ends everything
			}
			stage.addEventListener(KeyboardEvent.KEY_DOWN, downkey);
			function downkey(e:KeyboardEvent):void
			{//when any of these are true, movePlayer() will pull in corisponding direction
				if (e.keyCode == 65 || e.keyCode == 37)wGrav = true;
				if (e.keyCode == 87 || e.keyCode == 38)nGrav = true;
				if (e.keyCode == 68 || e.keyCode == 39)eGrav = true;
				if (e.keyCode == 83 || e.keyCode == 40)sGrav = true;
				//when "i" is pressed, display instructions from xml
				if (e.keyCode == 73)
				{//when you press i, add controls and instructions to screen
					addChild(conTxt);
					addChild(instTxt);
				}
				if (e.keyCode == 82) restart();
			}
			stage.addEventListener(KeyboardEvent.KEY_UP, upkey);
			function upkey(e:KeyboardEvent):void
			{//stops pulling player
				if (e.keyCode == 65 || e.keyCode == 37)wGrav = false;
				if (e.keyCode == 87 || e.keyCode == 38)nGrav = false;
				if (e.keyCode == 68 || e.keyCode == 39)eGrav = false;
				if (e.keyCode == 83 || e.keyCode == 40)sGrav = false;
				//stop showing instructions when let go
				if (e.keyCode == 73)
				{
					removeChild(conTxt);
					removeChild(instTxt);
				}
			}
			myLoader.addEventListener(Event.COMPLETE, processXML);
			function processXML(e:Event):void
			{
				myXML = new XML(e.target.data);
				instTxt.text = String(myXML.howtoplay);//makes instTxt = to xml value
				conTxt.text = String(myXML.controlls);//sometimes spelling errors are nessesary to prevent computer errors
			}
//functions
			function healthBar():void
			{//changes the position and width of filler inside of health bar
				if (lives > 0){
					filler.width = 20 * lives;
					filler.x = 10 * lives + 1;
					addChild(filler);//keeps filler on top of bubs/explosions so you can see health always
				}//so bar doesn't glitch when negative when playing fullscreen
				else filler.width = 0;
			}
			function movePlayer():void
			{//pulls player in direction, as long as they're not going offscreen
				if (wGrav == true && p.x > 0)p.x -=  10;
				if (nGrav == true && p.y > 0)p.y -=  10;
				if (eGrav == true && p.x < 550)p.x +=  10;
				if (sGrav == true&& p.y < 400)p.y +=  10;
			}
			function spawnBubs():void
			{//spawns bubArrays
				var bub:orb = new orb();//make a bubble
				bub.width = 15;
				bub.height = 15;
				myColorTransform.color = Math.random() * 0xFFFFFF;
				bub.transform.colorTransform = myColorTransform;
				bubArray.push(bub);//add it to the bubArray
				addChild(bub);
				//random number between 0-5, choses what side bubs will spawn. Might not be 25% even chances
				if (spawnSide <= 1)
				{//North
					bubArray[bubArray.length - 1].x = Math.random() * 450 + 50;//bubs dont spawn on outer 50px
					bubArray[bubArray.length - 1].y = 1;
					bxArray.push(Math.random() * 20 - 10);
					byArray.push(Math.random() * 10);
				}
				if (spawnSide == 2)
				{//East
					bubArray[bubArray.length - 1].x = 549;
					bubArray[bubArray.length - 1].y = Math.random() * 300 + 50;
					bxArray.push(Math.random() * -10);
					byArray.push(Math.random() * 20 - 10);
				}
				if (spawnSide == 3)
				{//South
					bubArray[bubArray.length - 1].x = Math.random() * 450 + 50;
					bubArray[bubArray.length - 1].y = 399;
					bxArray.push(Math.random() * 20 - 10);
					byArray.push(Math.random() * -10);
				}
				if (spawnSide >= 4)
				{//WEST SIDE REP!@!@!
					bubArray[bubArray.length - 1].x = 1;
					bubArray[bubArray.length - 1].y = Math.random() * 300 + 50;
					bxArray.push(Math.random() * 10);
					byArray.push(Math.random() * 20 - 10);
				}
				spawnSide = Math.floor(Math.random() * 5);//if its 4, you will VERY rarely get a 4, only 3.x
			}
			function moveBubs():void
			{//moves bubbles and deals with heir hitboxes
				for (var k:Number = 0; k < bubArray.length; k++)
				{//moves bubble array at its speed
					bubArray[k].x +=  bxArray[k];
					bubArray[k].y +=  byArray[k];
					if (bubArray[k].hitTestObject(p)){//when it hits a player
						if (bubArray[k].width > 16) lives--;//evil bubbles will ALWAYYS be more than 15 in width
						else score++;//if you still have lives and the bub wasn't evil, add to score
						bubRemove(k);
						spawnRate -= Math.random() / 10;
					}	//every score that you get, it lowers the amount of ticks inbetween spawnBubs by 0-0.1
				}
			}
			function hitBubs():void
			{//removes bubbles offscreen, exicutes explode when two hit eachother
				for (var k:Number = 0; k < bubArray.length; k++)
				{
					if (bubArray[k].y > 415 || bubArray[k].y < -15 || bubArray[k].x > 565 || bubArray[k].x < -15)
					{//when bub goes offscreen, remove it
						bubRemove(k);
						break;
					}
					for (var j:uint = k + 1; j < bubArray.length; j++)
					{
						if (k != j && bubArray[k].hitTestObject(bubArray[j]))
						{//when a bub hits a bub remove them both and run explode, pass through x and y coord
							explode(bubArray[j].x, bubArray[j].y);
							bubRemove(j);
							bubRemove(k);
							break;
						}
					}
				}
			}
			function changeBubs():void
			{//creates evil bubbles, makes explosions bigger and removes them when needed
				for (var e:Number = 0; e < bubArray.length; e++)
				{//no difference from normal bubs other than a larger diamiter and a red color
					for (var u:Number = 0; u < exArray.length; u++)
					{
						if (bubArray[e].hitTestObject(exArray[u]))
						{
							myColorTransform.color = 0xFF0000;
							bubArray[e].transform.colorTransform = myColorTransform;
							bxArray[e] *= 1.1;//the longer the bub is in the explosion, the faster/larger itll be
							byArray[e] *= 1.1;
							bubArray[e].width += 1.5;
							bubArray[e].height += 1.5;
						}
					}
				}
				for (var j:Number = 0; j < exArray.length; j++)
				{
					if (exArray[j].hitTestObject(p))
					{//if you hit an exploding bubble, remove it and you lose a life
						lives--;
						removeChild(exArray[j]);
						exArray.splice(j, 1);
						break;
					}
					exArray[j].width +=  .7;
					exArray[j].height +=  .7;
					if (exArray[j].width > 140)
					{//when it reaches maximum diamiter remove it
						removeChild(exArray[j]);
						exArray.splice(j, 1);
						break;
					}
				}
			}
			function refreshTxt():void
			{//keep refreshing text
				scoreTxt.text = String(score);
				scoreTxt.setTextFormat(sf);
				timeTxt.text = String(time);
				timeTxt.setTextFormat(sf);
			}
			function timers():void
			{
				var now:Date = new Date();
				curTime = now.getTime();//current time is always updated to keep track of time since restart
				if (lives > 0) time = Math.floor((curTime - startTime) / 1000)//(time now - time started)ms converted to seconds
				if (time > 3 && infoTxt.x == 10) infoTxt.x = 900;//can't remove this child so i have to hide it
			}
			function endGame():void
			{
				spawnRate = 1000000000;//so no more spawn(for a while)
				for (var i:Number = 0; i < bubArray.length; i++) bubRemove(i);
				//suppose to remove everything offfscreen, doesn't always work perfectly
				for (var j:Number = 0; j < exArray.length; j++)
				{
					removeChild(exArray[j]);
					exArray.splice(j, 1);
				}
			}
			function restart():void
			{
				if (lives > 0) endGame();//if they're restarting while still in a game, they need to run enggame
				spawnRate = 8;//restarts the spawnrate
				if (score > hscore) hscore = score;//if new highscore is achived, replace old
				hscoreTxt.text = String(hscore);
				addChild(hscoreTxt);//do this for the first time now so on their first run they dont see hs of 0
				if (time > htime) htime = time;
				htimeTxt.text  = String(htime);
				startTime = curTime;
				addChild(htimeTxt);
				score = 0;//rests variables
				time = 0;
				lives = 5;
				infoTxt.x = 10;//brings the "click i for info" up for a while more
				p.x = 275;
				p.y = 200;
			}
			function explode(bx, by):void
			{//spawns an exploding bubble at the x and y coord passed through function
				var exBub:orb = new orb();
				exArray.push(exBub);
				exArray[exArray.length - 1].width = 15;
				exArray[exArray.length - 1].height = 15;
				exArray[exArray.length - 1].x = bx;
				exArray[exArray.length - 1].y = by;
				addChild(exArray[exArray.length - 1]);
			}
			function bubRemove(i):void
			{//removes a bubble, had to copy this code many times so I put it in it's own function
				removeChild(bubArray[i]);
				bubArray.splice(i, 1);
				bxArray.splice(i, 1);
				byArray.splice(i, 1);
			}
		}
	}
}