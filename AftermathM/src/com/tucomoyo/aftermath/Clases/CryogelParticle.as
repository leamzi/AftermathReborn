package com.tucomoyo.aftermath.Clases 
{
	import com.tucomoyo.aftermath.Engine.AssetManager;
	import flash.geom.Point;
	
	import starling.core.Starling;
	import starling.display.MovieClip;
	
	/**
	 * ...
	 * @author predictivia
	 */
	public class CryogelParticle extends MovieClip 
	{
		/*public var target:Point; //punto objetivo del chorro
		public var choque:Boolean=false; //verificación de impacto con el suelo
		public var velocity:Point; //velocidad de desplazamiento que será en función de la distancia
		public var oTarget:Objetos;
		
		public function CryogelParticle(_X:int,_Y:int, d_X:int,d_Y:int, _oTarget:Objetos,textureScene:AssetManager) 
		{
			super(textureScene.getAtlas("cryogel").getTextures("water"), 5);
			
			this.pivotX=Math.ceil(this.width/2);
			this.pivotY=Math.ceil(this.height/2);
			this.x = _X; // se situa el pto de partida
			this.y = _Y;
			this.oTarget = _oTarget;
			
			velocity = new Point((d_X-_X)/47.5,(d_Y-_Y)/47.5);
			target = new Point(d_X,d_Y);
			
		}
		
		public function update_particle():Boolean
		{
			
			
			if (Math.sqrt(((this.x-target.x)*(this.x-target.x))+((this.y-target.y)*(this.y-target.y))) < 5 && ! choque)
			{
				choque = true;
				velocity.x=0;
				velocity.y=0;
				this.currentFrame=3;
				
			}
			if (! choque)
			{
				if (this.currentFrame == 2)
				{
					this.currentFrame=0;
				}
			}
			else
			{
				if (this.currentFrame == 6)
				{
					this.visible=false;
					return true;
				}
			}
			
			this.y += velocity.y;
			this.x += velocity.x;
			
			return false;
			
		}
		
		override public function dispose():void 
		{
			oTarget = null;
			target = null;
			velocity = null;
			
			super.dispose();
		}
	 */
	}

}