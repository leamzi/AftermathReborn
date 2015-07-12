package com.tucomoyo.aftermath.Clases 
{
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Sprite;
	import com.tucomoyo.aftermath.starling.extensions.PDParticleSystem;
	import starling.textures.Texture;
	import starling.animation.Transitions;
	
	/**
	 * ...
	 * @author Predictvia
	 */
	public class Particle extends Sprite 
	{
		// Particula de Disparo de Crystal Spawm -----------------------
		
		//[Embed(source="../../../../../media/graphics/Particle/explotionPs.pex", mimeType="application/octet-stream")]
		//private static const csShootConfig:Class;
//
		// embed particle texture
		//[Embed(source = "../../../../../media/graphics/Particle/explotionPs.png")]
		//private static const csShootParticle:Class;
		//
		// instantiate embedded objects
		//public var psCsShootConfig:XML = XML(new csShootConfig());
		//public var psCsShootTexture:Texture = Texture.fromBitmap(new csShootParticle());
//
		// create particle system
		//public var psCsShoot:PDParticleSystem = new PDParticleSystem(psCsShootConfig, psCsShootTexture);
		
		// Particula de Explosion -----------------------
		
		[Embed(source="../../../../../media/graphics/Particle/explotionPs.pex", mimeType="application/octet-stream")]
		private static const explosionConfig:Class;

		// embed particle texture
		[Embed(source = "../../../../../media/graphics/Particle/explotionPs.png")]
		private static const explosionParticle:Class;
		
		// instantiate embedded objects
		public var psExplosionConfig:XML = XML(new explosionConfig());
		public var psExplosionTexture:Texture = Texture.fromBitmap(new explosionParticle());

		// create particle system
		public var psExplosion:PDParticleSystem = new PDParticleSystem(psExplosionConfig, psExplosionTexture);
		
		// Particula del Cryogel -----------------------
		
		[Embed(source="../../../../../media/graphics/Particle/shootPs.pex", mimeType="application/octet-stream")]
		private static const shootConfig:Class;

		// embed particle texture
		[Embed(source = "../../../../../media/graphics/Particle/shootPs.png")]
		private static const shootParticle:Class;
		
		// instantiate embedded objects
		public var psShootConfig:XML = XML(new shootConfig());
		public var psShootTexture:Texture = Texture.fromBitmap(new shootParticle());

		// create particle system
		public var psShoot:PDParticleSystem = new PDParticleSystem(psShootConfig, psShootTexture);
		
		public function Particle(type:String) 
		{
			super();
			
			switch (type) 
			{
				case "cShotParticle":
					psShoot.x = 0;
					psShoot.y = 0;
					addChild(psShoot);
					Starling.juggler.add(psShoot);

					// change position where particles are emitted
					psShoot.emitterX = 0;
					psShoot.emitterY = 0;

					// start emitting particles
					psShoot.start();
				break;
				case "explotionParticle":
					psExplosion.x = 0;
					psExplosion.y = 0;
					addChild(psExplosion);
					Starling.juggler.add(psExplosion);
					
					psExplosion.stop();
					psExplosion.emitterType = 1;
					psExplosion.emitAngle = 0;    
					psExplosion.emitAngleVariance = Math.PI;
					psExplosion.maxRadius = 10;   
					psExplosion.maxRadiusVariance = 0;
					psExplosion.minRadius = 0;
					psExplosion.start();

					var tween:Tween = new Tween(psExplosion, 0.5, Transitions.LINEAR);
					tween.animate("maxRadius", 100);
					tween.animate("minRadius", 100);
					tween.onComplete = removeExplosion;
					Starling.juggler.add(tween);
				break;
				case "csShoot":
					
				break;
				default:
			}
			
		}
		
		public function explotionAnimation():void 
		{
			var tween:Tween;
			
			psShoot.stop();
			psShoot.emitterType = 1;
			psShoot.emitAngle = 0;    
			psShoot.emitAngleVariance = Math.PI;
			psShoot.maxRadius = 10;   
			psShoot.maxRadiusVariance = 0;
			psShoot.minRadius = 0;
			psShoot.start();
			
			tween = new Tween(psShoot, 0.5, Transitions.LINEAR);
			tween.animate("maxRadius", 100);
			tween.animate("minRadius", 100);
			tween.onComplete = removeCrystalExplotion;
			Starling.juggler.add(tween);
		}
			
		public function removeCrystalExplotion():void 
		{
					psShoot.stop();
					psShoot.maxRadius = 10;
					psShoot.minRadius = 0;
					psShoot.dispose();
		}
		
		public function removeExplosion():void 
		{
					psExplosion.stop();
					psExplosion.maxRadius = 10;
					psExplosion.minRadius = 0;
					psExplosion.dispose();
		}
		
		override public function dispose():void 
		{
			//--------------------
			if (psShoot!=null) 
			{
				psShoot.stop(true);
				Starling.juggler.remove(psShoot);
				psShoot.dispose();
				psShoot = null;
				psShootConfig = null;
				psShootTexture.dispose();
				psShootTexture = null;
			}
			
			
			//--------------------
			if (psExplosion!=null) 
			{
				psExplosion.stop(true);
				Starling.juggler.remove(psExplosion);
				psExplosion.dispose();
				psExplosion = null;
				psExplosionConfig = null;
				psExplosionTexture.dispose();
				psExplosionTexture = null;
			}
			
			super.dispose();
		}
		
	}

}