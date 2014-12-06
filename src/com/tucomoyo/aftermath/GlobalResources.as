package com.tucomoyo.aftermath 
{
	import com.google.analytics.AnalyticsTracker;
	import com.google.analytics.GATracker;
	import com.tucomoyo.aftermath.Clases.LoadingSplash;
	import com.tucomoyo.aftermath.Engine.releaseTraceConsole;
	import flash.system.LoaderContext;
	import flash.system.ApplicationDomain;
	import flash.system.SecurityDomain;
	/**
	 * ...
	 * @author Predictvia
	 * 
	 *  JSON IDIOMA http://www.objgen.com/json/models/4sDfL 
	 * 
	 */
	public class GlobalResources 
	{
		public var stageHeigth:int;
		public var stageWidth:int;
		public var user_id:String;
		public var facebookId:String;
		public var picture_url:String;
		public var acces_token:String;
		public var user_name:String;
		public var user_firstName:String;
		public var user_lastName:String;
		public var game_version:String;
		public var pref_url:String = "media/";
		public var myDomain:SecurityDomain = null
		public var tutorialDone:Boolean;
		public var GoogleAnalitics:Boolean = false;
		public var isInTutorial:Boolean = false;
		public var loaderContext:LoaderContext;
		public var loadingSplash:LoadingSplash;
		public var tracker:AnalyticsTracker;
		public var idioma:String = "Ingles";
		public var textos:Object;
		public var NpcInfo:Object;
		public var splashCount:int = 0;
		public var volume:Number = 0.5;
		public var friendsList:Array;
		public var fontName:String = "Gravity_Book";
		public var profileData:Object;
		public var console:releaseTraceConsole;
		
		//Embed the Fonts
		[Embed(source="../../../../media/fonts/embedded/Gravity_Book.ttf", fontFamily="MyfontName",fontName="Gravity_Book", embedAsCFF="false", mimeType = "application/x-font-truetype")]
		public static var Code:Class
		
		[Embed(source="../../../../media/fonts/embedded/LVDCD.ttf", fontFamily="MyfontName",fontName="LVDCD", embedAsCFF="false", mimeType = "application/x-font-truetype")]
		public static var Code2:Class
		
		[Embed(source="../../../../media/fonts/embedded/ERASBD.ttf", fontFamily="MyfontName",fontName="ERASBD", embedAsCFF="false", mimeType = "application/x-font-truetype")]
		public static var Code3:Class
		
		
		public function GlobalResources() 
		{
			
		}
		
		public function createConsole():releaseTraceConsole {
			
			console = new releaseTraceConsole();
			
			return console;
			
		}
		
		public function log(texto:String):void {
			
			console.log(texto);
			
		}
		
		
		public function activateSplash(count:int = -1):void {
			if (count > 0) {
				splashCount = count;
			}
			loadingSplash.activateTimer();
			loadingSplash.visible = true;
		}
		
		public function setCountSplash(count:int):void {
			
			splashCount = count;
		}
		
		public function deactivateSplash(flag:Boolean = false):void {
			if (flag) {
				if(--splashCount == 0){
					loadingSplash.visible = false;
					loadingSplash.deactivateTimer();
				}
			}else {
				loadingSplash.visible = false;
				loadingSplash.deactivateTimer();
			}
		}
		
		public function setVars():void {
			trace("GA = " + GoogleAnalitics);
			if (user_id == "-1") {
				
				//user_id = "3624"; //Isma
				user_id = "3621"; //Pablo
				//user_id = "3661"; //Yorch
				//user_id = "20"; //Aldo
				//user_id = "50";//rosa
				//user_id = "4078"; //Ui
				//user_id = "27";
				//user_id = "47"; //Frank
				//user_id = "4191"; //dummy fb
				acces_token = "4191_8_1424986320b5f2e8f5f56f1b0d68e5ed63c03ea2a46f24405b";
				picture_url = "https://d389o9kfupjsqw.cloudfront.net/users/3624/default_profile_3624_1375898783.jpg";
				user_name = "Ismael Serrada";
				user_firstName = "Ismael";
				user_lastName = "Serrada";
				facebookId = "718462734"; //Isma
				//facebookId = "707269337"; //Pablo
				friendsList = [
								{
								  "name": "Eduardo Buysse", 
								  "id": "500804201"
								}, 
								{
								  "name": "Daniel Garrido", 
								  "id": "500855904"
								}, 
								{
								  "name": "Ciro Durán", 
								  "id": "506370226"
								}, 
								{
								  "name": "Andrea Capriles de Ortega", 
								  "id": "516661315"
								}, 
								{
								  "name": "Jhoswell Carmona", 
								  "id": "519062840"
								}, 
								{
								  "name": "Danny Artist Ecr", 
								  "id": "521336947"
								}, 
								{
								  "name": "Alejandra Da Costa", 
								  "id": "525443479"
								}, 
								{
								  "name": "Andres Juarez", 
								  "id": "527974282"
								}, 
								{
								  "name": "Shirly Da Pinho", 
								  "id": "531805055"
								}, 
								{
								  "name": "Norcelin Pinillos", 
								  "id": "533399428"
								}, 
								{
								  "name": "Bricelis Urbina", 
								  "id": "535098587"
								}, 
								{
								  "name": "Claudia Carolina Del Carmen Betancourt Montes", 
								  "id": "535177485"
								}, 
								{
								  "name": "Marcos Alejandro Vasquez Perez", 
								  "id": "535218292"
								}, 
								{
								  "name": "Isaura Ruiz", 
								  "id": "538289777"
								}, 
								{
								  "name": "Alejandro Castro Quintero", 
								  "id": "538318841"
								}, 
								{
								  "name": "Veronica Alexandra Martinez", 
								  "id": "539490735"
								}, 
								{
								  "name": "Javier Prato", 
								  "id": "546828820"
								}, 
								{
								  "name": "Daniel J Lezama", 
								  "id": "550012307"
								}, 
								{
								  "name": "Yole Quintero", 
								  "id": "557081742"
								}, 
								{
								  "name": "Andrew Davis Escalona", 
								  "id": "557338582"
								}, 
								{
								  "name": "Nadra Maria Naveda Boscán", 
								  "id": "557790994"
								}, 
								{
								  "name": "Efraín Aramacuto", 
								  "id": "558249162"
								}, 
								{
								  "name": "Eduardo Calderon", 
								  "id": "561596109"
								}, 
								{
								  "name": "Marcos Temoche", 
								  "id": "564494179"
								}, 
								{
								  "name": "Enrique Mayorca", 
								  "id": "565211560"
								}, 
								{
								  "name": "José Joel", 
								  "id": "567421121"
								}, 
								{
								  "name": "Gari Roa", 
								  "id": "568122345"
								}, 
								{
								  "name": "Ninhoska Baduy", 
								  "id": "570741692"
								}, 
								{
								  "name": "Johana Baduy", 
								  "id": "570833567"
								}, 
								{
								  "name": "Daynor Urrecheaga", 
								  "id": "572083364"
								}, 
								{
								  "name": "Michael Cheung", 
								  "id": "574211638"
								}, 
								{
								  "name": "Ga Ba", 
								  "id": "577343781"
								}, 
								{
								  "name": "Pilar Hidalgo", 
								  "id": "577491687"
								}, 
								{
								  "name": "Miguel Angel Almeida", 
								  "id": "578310246"
								}, 
								{
								  "name": "Gerard Ruiz B", 
								  "id": "580547243"
								}, 
								{
								  "name": "Carlos Vivas", 
								  "id": "582073416"
								}, 
								{
								  "name": "Carlos Cromwell Jara", 
								  "id": "583782899"
								}, 
								{
								  "name": "Jose Rafael Guevara Salazar", 
								  "id": "586787649"
								}, 
								{
								  "name": "Luisa Torrealba", 
								  "id": "595046949"
								}, 
								{
								  "name": "Juan José", 
								  "id": "595698839"
								}, 
								{
								  "name": "Valentina Colmenarez", 
								  "id": "596165864"
								}, 
								{
								  "name": "Daniela Díaz Reyna", 
								  "id": "596395784"
								}, 
								{
								  "name": "Lorenzo Leal", 
								  "id": "605538856"
								}, 
								{
								  "name": "Jorge Cromwell", 
								  "id": "608147288"
								}, 
								{
								  "name": "Guillermo Velásquez", 
								  "id": "608876394"
								}, 
								{
								  "name": "David B. Gallart", 
								  "id": "610194651"
								}, 
								{
								  "name": "Maria Antonietta D'alessio R", 
								  "id": "610283081"
								}, 
								{
								  "name": "Priscila Ponton", 
								  "id": "611294009"
								}, 
								{
								  "name": "Vanessa Arévalo", 
								  "id": "613849731"
								}, 
								{
								  "name": "Giselle Acedo", 
								  "id": "617908937"
								}, 
								{
								  "name": "Isabelle Bellet", 
								  "id": "620512322"
								}, 
								{
								  "name": "Luis Davila Beto", 
								  "id": "622545144"
								}, 
								{
								  "name": "Ronald Arias", 
								  "id": "623791947"
								}, 
								{
								  "name": "Luis Ricardo Ortega Arias", 
								  "id": "628660112"
								}, 
								{
								  "name": "Aldo Fabrizio Porco", 
								  "id": "630346167"
								}, 
								{
								  "name": "Paul Pereda", 
								  "id": "634052064"
								}, 
								{
								  "name": "Alejandro Ramirez", 
								  "id": "634458105"
								}, 
								{
								  "name": "Javier Correia", 
								  "id": "634916195"
								}, 
								{
								  "name": "Andreina Cabrera", 
								  "id": "635115693"
								}, 
								{
								  "name": "Gabriel Rodriguez Hernandez", 
								  "id": "638950440"
								}, 
								{
								  "name": "José Luis Andrade", 
								  "id": "639366477"
								}, 
								{
								  "name": "Edgar Bernal", 
								  "id": "639788730"
								}, 
								{
								  "name": "Victoria Hercilia", 
								  "id": "640108569"
								}, 
								{
								  "name": "Luisinho Franco", 
								  "id": "641463941"
								}, 
								{
								  "name": "Kelly Aguilar", 
								  "id": "641862534"
								}, 
								{
								  "name": "Paola Temoche Erquiaga", 
								  "id": "642133366"
								}, 
								{
								  "name": "Frank Fernow", 
								  "id": "643022278"
								}, 
								{
								  "name": "Luis Fernando Bárcena Flores", 
								  "id": "644931542"
								}, 
								{
								  "name": "Ernesto Olivo Valverde", 
								  "id": "650902175"
								}, 
								{
								  "name": "Yessica Hernandez", 
								  "id": "655922385"
								}, 
								{
								  "name": "Dante Rodríguez", 
								  "id": "658779722"
								}, 
								{
								  "name": "Omaira Rodriguez G.", 
								  "id": "660063490"
								}, 
								{
								  "name": "Yoimy Gil", 
								  "id": "660158344"
								}, 
								{
								  "name": "Haymara Palma", 
								  "id": "668817538"
								}, 
								{
								  "name": "Victor Hugo Wang Flores", 
								  "id": "670126436"
								}, 
								{
								  "name": "Mariana Colombo", 
								  "id": "673692601"
								}, 
								{
								  "name": "Emgelbert Farfán Castro", 
								  "id": "675934002"
								}, 
								{
								  "name": "Daniel Moreno", 
								  "id": "679715375"
								}, 
								{
								  "name": "Santiago Batenburg", 
								  "id": "681542907"
								}, 
								{
								  "name": "Angel S. Olórtegui", 
								  "id": "684386766"
								}, 
								{
								  "name": "Iris Aguilar", 
								  "id": "685988314"
								}, 
								{
								  "name": "Jesus Moran", 
								  "id": "686185304"
								}, 
								{
								  "name": "Johnny Mendez", 
								  "id": "690814330"
								}, 
								{
								  "name": "Viviana Pérez", 
								  "id": "696520104"
								}, 
								{
								  "name": "Maria De Los Angeles Montilla", 
								  "id": "699206205"
								}, 
								{
								  "name": "Josimar Cordova", 
								  "id": "700941738"
								}, 
								{
								  "name": "Erica Pérez", 
								  "id": "702271546"
								}, 
								{
								  "name": "Maria Elena Poó Arguello", 
								  "id": "702410458"
								}, 
								{
								  "name": "Luis Bastidas", 
								  "id": "702440338"
								}, 
								{
								  "name": "Carlo Cassani Velàzquez", 
								  "id": "706301113"
								}, 
								{
								  "name": "Arthur Cordova", 
								  "id": "706487221"
								}, 
								{
								  "name": "Barbara Teran", 
								  "id": "707004136"
								}, 
								{
								  "name": "Luis Orlando Lessey Vivas", 
								  "id": "708023625"
								}, 
								{
								  "name": "Juan Carlos Ferro", 
								  "id": "710535889"
								}, 
								{
								  "name": "Andres Barrera", 
								  "id": "713435280"
								}, 
								{
								  "name": "Marijo Veaknet", 
								  "id": "713812315"
								}, 
								{
								  "name": "Jorge Antonio Pepe Cortés", 
								  "id": "714690708"
								}, 
								{
								  "name": "Rosamar Osorio", 
								  "id": "714854972"
								}, 
								{
								  "name": "Pedro Bravo Salom", 
								  "id": "715706526"
								}, 
								{
								  "name": "Ismael Serrada", 
								  "id": "718462734"
								}, 
								{
								  "name": "Clara Perez", 
								  "id": "719197363"
								}, 
								{
								  "name": "Antonieta Zerré", 
								  "id": "720781479"
								}, 
								{
								  "name": "Dubraska Atencio de Cruz", 
								  "id": "721143116"
								}, 
								{
								  "name": "Jorge Bernadas", 
								  "id": "722360662"
								}, 
								{
								  "name": "Fox Gary Arias Gomez", 
								  "id": "724386626"
								}, 
								{
								  "name": "Miguel Alfonzo Chang", 
								  "id": "726544848"
								}, 
								{
								  "name": "Lorena Matilde González Inneco", 
								  "id": "727643436"
								}, 
								{
								  "name": "Luis Miguel Castillo Mendoza", 
								  "id": "728932290"
								}, 
								{
								  "name": "Cesar Augusto Perez Santos", 
								  "id": "729963571"
								}, 
								{
								  "name": "Felix Oliveros", 
								  "id": "730001718"
								}, 
								{
								  "name": "Ortíz Villegas María", 
								  "id": "732924089"
								}, 
								{
								  "name": "Jesus Simanca", 
								  "id": "736415128"
								}, 
								{
								  "name": "Augusto Zapata", 
								  "id": "739850409"
								}, 
								{
								  "name": "Carlos Raúl Borrero", 
								  "id": "742328073"
								}, 
								{
								  "name": "Greisy Guzman Zambrano", 
								  "id": "747703951"
								}, 
								{
								  "name": "Jonatan N Rivera", 
								  "id": "749350818"
								}, 
								{
								  "name": "Juan Carlos De Abreu", 
								  "id": "750657338"
								}, 
								{
								  "name": "Pedro Caicedo", 
								  "id": "754758805"
								}, 
								{
								  "name": "Antonio Rueda", 
								  "id": "755829760"
								}, 
								{
								  "name": "Luis Aguiar", 
								  "id": "756443553"
								}, 
								{
								  "name": "Valeria Coffaro", 
								  "id": "756885290"
								}, 
								{
								  "name": "Jorge Padua", 
								  "id": "760519851"
								}, 
								{
								  "name": "Adriano Cattini", 
								  "id": "761330595"
								}, 
								{
								  "name": "Devi Carolina S. Olortegui", 
								  "id": "766114922"
								}, 
								{
								  "name": "Miguel Flores", 
								  "id": "768442175"
								}, 
								{
								  "name": "Estefania Rodriguez De Paolini", 
								  "id": "769099288"
								}, 
								{
								  "name": "Augusto Andres Ramirez Colmenares", 
								  "id": "773167064"
								}, 
								{
								  "name": "Fernando Melgar Fernández", 
								  "id": "776639224"
								}, 
								{
								  "name": "Robinson Rivas Suárez", 
								  "id": "778347762"
								}, 
								{
								  "name": "Laura Gomez", 
								  "id": "784314555"
								}, 
								{
								  "name": "Yusnaibeth Linyu Chamuel", 
								  "id": "786880367"
								}, 
								{
								  "name": "Luis Manuel Castillo Mendoza", 
								  "id": "788188209"
								}, 
								{
								  "name": "Daniel Ampuero", 
								  "id": "820540137"
								}, 
								{
								  "name": "Sergio Javier Lopez Garcia", 
								  "id": "836205272"
								}, 
								{
								  "name": "Ken Luna", 
								  "id": "870895034"
								}, 
								{
								  "name": "Carlos Arandia", 
								  "id": "874045190"
								}, 
								{
								  "name": "Silvia Carolina Leonard Ramirez", 
								  "id": "891085552"
								}, 
								{
								  "name": "Jeniffer Lopez", 
								  "id": "892460547"
								}, 
								{
								  "name": "Marina Daoud Jungblut", 
								  "id": "893405013"
								}, 
								{
								  "name": "María Leonor Pacheco", 
								  "id": "1008901544"
								}, 
								{
								  "name": "Evelyn De León", 
								  "id": "1021546596"
								}, 
								{
								  "name": "Edgely Carolina", 
								  "id": "1023034380"
								}, 
								{
								  "name": "Miguel Obando", 
								  "id": "1026835630"
								}, 
								{
								  "name": "Hernan Alfonso Fernandez Castilla", 
								  "id": "1027744325"
								}, 
								{
								  "name": "Arnaldo Añez", 
								  "id": "1030114746"
								}, 
								{
								  "name": "David Ochoa", 
								  "id": "1039250758"
								}, 
								{
								  "name": "Alejandra Temoche Erquiaga", 
								  "id": "1041644126"
								}, 
								{
								  "name": "Cindy De Almada", 
								  "id": "1043689050"
								}, 
								{
								  "name": "José Martinez", 
								  "id": "1051107764"
								}, 
								{
								  "name": "Humberto Flores", 
								  "id": "1052687580"
								}, 
								{
								  "name": "Karina Flores", 
								  "id": "1066931838"
								}, 
								{
								  "name": "Rasel Bermudez Toro", 
								  "id": "1073494035"
								}, 
								{
								  "name": "Jely Gonzalez", 
								  "id": "1076501070"
								}, 
								{
								  "name": "Alejandro Martinez", 
								  "id": "1092826560"
								}, 
								{
								  "name": "German Caballero", 
								  "id": "1093805820"
								}, 
								{
								  "name": "Bertha Marina Jara Temoche", 
								  "id": "1097531258"
								}, 
								{
								  "name": "Tiziana Lopez", 
								  "id": "1101897865"
								}, 
								{
								  "name": "Jorge Juarez", 
								  "id": "1106212662"
								}, 
								{
								  "name": "Mariana Bastidas", 
								  "id": "1108292279"
								}, 
								{
								  "name": "Jose Schmidt Pérez", 
								  "id": "1112710173"
								}, 
								{
								  "name": "Gil Padrino", 
								  "id": "1113734520"
								}, 
								{
								  "name": "José Antonio Torrealba Gil", 
								  "id": "1119642560"
								}, 
								{
								  "name": "Edwin Escárate", 
								  "id": "1122848552"
								}, 
								{
								  "name": "Yelitza Teran", 
								  "id": "1132386944"
								}, 
								{
								  "name": "Elena Nicoletti", 
								  "id": "1134651923"
								}, 
								{
								  "name": "Rhadamés Carmona", 
								  "id": "1135546908"
								}, 
								{
								  "name": "Ana Rangel", 
								  "id": "1135625932"
								}, 
								{
								  "name": "Alexis Gil", 
								  "id": "1141869003"
								}, 
								{
								  "name": "Rafael Hernandez", 
								  "id": "1145191593"
								}, 
								{
								  "name": "Kijam Lopez", 
								  "id": "1145311073"
								}, 
								{
								  "name": "Doheidy Gil", 
								  "id": "1149323339"
								}, 
								{
								  "name": "Adriana Argüello", 
								  "id": "1149894707"
								}, 
								{
								  "name": "Vanessa GarLe", 
								  "id": "1155195531"
								}, 
								{
								  "name": "David El Rahi", 
								  "id": "1155673017"
								}, 
								{
								  "name": "Abel Lavieri", 
								  "id": "1159867855"
								}, 
								{
								  "name": "Roberto K Meléndez Ch", 
								  "id": "1179408692"
								}, 
								{
								  "name": "Celso Anlas Valverde", 
								  "id": "1190166905"
								}, 
								{
								  "name": "Genna Mcs", 
								  "id": "1198590579"
								}, 
								{
								  "name": "Felm Val", 
								  "id": "1200602765"
								}, 
								{
								  "name": "Jenyree Alvarez", 
								  "id": "1207868313"
								}, 
								{
								  "name": "Cronwell Jara Temoche", 
								  "id": "1208344686"
								}, 
								{
								  "name": "Ivan Zea Acuña", 
								  "id": "1231520134"
								}, 
								{
								  "name": "Meryenin Aramacuto", 
								  "id": "1240645683"
								}, 
								{
								  "name": "Mariana García", 
								  "id": "1259746389"
								}, 
								{
								  "name": "Kevin Tambasco", 
								  "id": "1272726789"
								}, 
								{
								  "name": "Simón Barrios Bravo", 
								  "id": "1289127205"
								}, 
								{
								  "name": "Paola Temoche Nicoletti", 
								  "id": "1324884312"
								}, 
								{
								  "name": "Noel Campos", 
								  "id": "1385612325"
								}, 
								{
								  "name": "N David Jaimes", 
								  "id": "1398875619"
								}, 
								{
								  "name": "Johalys Mora", 
								  "id": "1422469777"
								}, 
								{
								  "name": "Clareidy Gil Padrino", 
								  "id": "1440044170"
								}, 
								{
								  "name": "Iris Espinoza", 
								  "id": "1474570760"
								}, 
								{
								  "name": "Yajaira Gil", 
								  "id": "1504498556"
								}, 
								{
								  "name": " flora carolinasenior", 
								  "id": "1530519687"
								}, 
								{
								  "name": "Flor Nunez", 
								  "id": "1579464921"
								}, 
								{
								  "name": "Kike Delfin", 
								  "id": "1580754839"
								}, 
								{
								  "name": "Germain Aramacuto", 
								  "id": "1642434039"
								}, 
								{
								  "name": "Marco Delfin", 
								  "id": "1662318978"
								}, 
								{
								  "name": "Fernando Saavedra Poma", 
								  "id": "1664202429"
								}, 
								{
								  "name": "Luis Hidalgo", 
								  "id": "1667000955"
								}, 
								{
								  "name": "Clara Magallanes Fernandez", 
								  "id": "1692832002"
								}, 
								{
								  "name": "Ailyn Belisario Gil", 
								  "id": "1733010092"
								}, 
								{
								  "name": "Luis David Garcia Teran", 
								  "id": "1802753294"
								}, 
								{
								  "name": "Ibrahin Aramacuto", 
								  "id": "1814733752"
								}, 
								{
								  "name": "Luz Mendoza Ramirez", 
								  "id": "1822562390"
								}, 
								{
								  "name": "Maryelin Aramacuto", 
								  "id": "1836143914"
								}, 
								{
								  "name": "David Rubel", 
								  "id": "100000120748110"
								}, 
								{
								  "name": "Judith Ilave Benites", 
								  "id": "100000166723250"
								}, 
								{
								  "name": "Soluciones Integrales Vox", 
								  "id": "100000252013303"
								}, 
								{
								  "name": "Daniel Delfin", 
								  "id": "100000272978069"
								}, 
								{
								  "name": "Edge Carolina", 
								  "id": "100000330858699"
								}, 
								{
								  "name": "Enrique Marin", 
								  "id": "100000355997769"
								}, 
								{
								  "name": "Renzo Temoche Erquiaga", 
								  "id": "100000413275466"
								}, 
								{
								  "name": "Yanorke Temoche Gil", 
								  "id": "100000440256106"
								}, 
								{
								  "name": "Jorge Flores", 
								  "id": "100000462604522"
								}, 
								{
								  "name": "Susana Duymovich", 
								  "id": "100000474684038"
								}, 
								{
								  "name": "Yinett Torrealba", 
								  "id": "100000518201262"
								}, 
								{
								  "name": "Richard Franco", 
								  "id": "100000522524776"
								}, 
								{
								  "name": "Karina G. Pedrique Rupérez", 
								  "id": "100000526498398"
								}, 
								{
								  "name": "Pedro Manuel Roque Laines", 
								  "id": "100000569332259"
								}, 
								{
								  "name": "Luis Angel Romero Mollo", 
								  "id": "100000652028866"
								}, 
								{
								  "name": "Francisco Javier Suárez", 
								  "id": "100000695436427"
								}, 
								{
								  "name": "Andres Garcia S", 
								  "id": "100000839731986"
								}, 
								{
								  "name": "Eglysmar Gonzalez", 
								  "id": "100000963650343"
								}, 
								{
								  "name": "Marissa Katherine Mendoza Sanchez", 
								  "id": "100001006965385"
								}, 
								{
								  "name": "Keyla Xiomara Gil Rodriguez", 
								  "id": "100001033035943"
								}, 
								{
								  "name": "Nelida Gil", 
								  "id": "100001034740595"
								}, 
								{
								  "name": "Hendry F Chame", 
								  "id": "100001060909526"
								}, 
								{
								  "name": "Hector Navarro", 
								  "id": "100001067801300"
								}, 
								{
								  "name": "Marlene Gil de Aramacuto", 
								  "id": "100001088585709"
								}, 
								{
								  "name": "Yulmarys Gonzalez", 
								  "id": "100001273238388"
								}, 
								{
								  "name": "Fuipuv Filantropía", 
								  "id": "100001273565066"
								}, 
								{
								  "name": "Yerfrank Gregorio Aramacuto Gil", 
								  "id": "100001309969346"
								}, 
								{
								  "name": "Luz Temoche Vasquez", 
								  "id": "100001475718269"
								}, 
								{
								  "name": "Sarita Ramirez P", 
								  "id": "100001536490853"
								}, 
								{
								  "name": "Exalumnos Sanpedranos", 
								  "id": "100001764741488"
								}, 
								{
								  "name": "Emilio Villar", 
								  "id": "100001973210667"
								}, 
								{
								  "name": "Julio Ernesto Roque Laines", 
								  "id": "100002072362328"
								}, 
								{
								  "name": "Sujhei Asencios Cordova", 
								  "id": "100002109819801"
								}, 
								{
								  "name": "Diogenes Jesus", 
								  "id": "100002137851610"
								}, 
								{
								  "name": "Juan Diego Parra", 
								  "id": "100002225811692"
								}, 
								{
								  "name": "Reynaldo Reyes", 
								  "id": "100002323399929"
								}, 
								{
								  "name": "Dilia Ortega", 
								  "id": "100002543923116"
								}, 
								{
								  "name": "Oscar Quintero", 
								  "id": "100002634845036"
								}, 
								{
								  "name": "Genesis Eche Jara", 
								  "id": "100002745548507"
								}, 
								{
								  "name": "Alx Claro", 
								  "id": "100003008154767"
								}, 
								{
								  "name": "Bertha Rosa Delfin Temoche", 
								  "id": "100003133869669"
								}, 
								{
								  "name": "Alanies Delfin", 
								  "id": "100003263529300"
								}, 
								{
								  "name": "Jessica Meza", 
								  "id": "100003282913331"
								}, 
								{
								  "name": "Coco Sun Han", 
								  "id": "100003314673569"
								}, 
								{
								  "name": "Cronwell Jara U", 
								  "id": "100003961428210"
								}, 
								{
								  "name": "Luz Maria Silva Cahuana", 
								  "id": "100003980520623"
								}, 
								{
								  "name": "Adrian Jesus Silva Simoes", 
								  "id": "100004177200922"
								}, 
								{
								  "name": "Yerfrank Aramacuto", 
								  "id": "100004273111668"
								}, 
								{
								  "name": "Cesar Nieves", 
								  "id": "100004342868282"
								}, 
								{
								  "name": "Edu SocialPoint", 
								  "id": "100005145243266"
								}, 
								{
								  "name": "Yessica Hernandez", 
								  "id": "100005306525747"
								}, 
								{
								  "name": "Lina Alondra", 
								  "id": "100005498023167"
								}, 
								{
								  "name": "Yanfer Melgar", 
								  "id": "100005810348941"
								}, 
								{
								  "name": "Eliana Temoche Erquiaga", 
								  "id": "100005812033925"
								}, 
								{
								  "name": "Aalgo Hacer", 
								  "id": "100006511909886"
								}, 
								{
								  "name": "Egresados Compu Ucv", 
								  "id": "100006798398148"
								}, 
								{
								  "name": "Ross Ortega", 
								  "id": "100006883260318"
								}
							  ];
				tutorialDone = true;
				
				profileData = new Object();
				profileData.bishcoins = 1000;
				profileData.vehicleData = new Object();
				profileData.vehicleData.cryogel = 0.0;
				profileData.vehicleData.fuel = 0.0;
				profileData.vehicleData.shieldValue = 0.0;
				profileData.vehicleData.damage = 0.0;
				profileData.vehicleData.velocityValue = 0.0;
				profileData.vehicleData.body = 0;
				profileData.vehicleData.weapon = -1;
				profileData.vehicleData.shield = -1;
				profileData.vehicleData.bodiesBought = [0,1];
				//pref_url = "https://s3.amazonaws.com/tucomoyo-games/aftermath/8k1103/media/";
					
			}else {
				
				this.myDomain = SecurityDomain.currentDomain;
				pref_url = "https://s3.amazonaws.com/tucomoyo-games/aftermath/"+game_version+"/media/";
				//_flag = true;
			}
			
			//this.myDomain = SecurityDomain.currentDomain;
			//game_version = "4a9482";
			//pref_url = "https://s3.amazonaws.com/tucomoyo-games/aftermath/" + game_version + "/media/";
			
			loaderContext  = new LoaderContext(true, ApplicationDomain.currentDomain, myDomain);
			
			loadingSplash = new LoadingSplash(this);
			deactivateSplash();
			
		}
		
		public function trackEvent(_category:String, _action:String, _label:String):void {
			
			if (GoogleAnalitics) 
			{
				tracker.trackEvent(_category, _action, _label);
			}
		}
		
		public function trackPageview(pageURL:String):void {
			if (GoogleAnalitics) 
			{
				tracker.trackPageview(pageURL);
			}
		}
		
	}

}