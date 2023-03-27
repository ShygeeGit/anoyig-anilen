package shaders;

import flixel.system.FlxAssets.FlxShader;
import openfl.filters.ShaderFilter;
import flixel.FlxG;

class Bloom extends FlxShader
{
    public static var blshader:ShaderFilter;

	@:glFragmentSource('
    #pragma header

    const float amount = 2.0;
    
        // GAUSSIAN BLUR SETTINGS
          float dim = 1.8;
        float Directions = 26.0;
        float Quality = 4.0; 
        float Size = 8.0; 
        vec2 Radius = Size/openfl_TextureSize.xy;
    void main(void)
    { 
    
    
    
        vec2 uv = openfl_TextureCoordv.xy ;
    
        vec2 pixel  = uv*openfl_TextureSize.xy ;
    
    float Pi = 6.28318530718; // Pi*2
        
        
    
        vec4 Color = texture2D( bitmap, uv);
        
        for( float d=0.0; d<Pi; d+=Pi/Directions){
            for(float i=1.0/Quality; i<=1.0; i+=1.0/Quality){
                
    
    Color += flixel_texture2D( bitmap, uv+vec2(cos(d),sin(d))*Size*i/openfl_TextureSize.xy);	
    
    
    
    
    
    
        
            }
        }
        
        Color /= (dim * Quality) * Directions - 15.0;
      vec4 bloom =  (flixel_texture2D( bitmap, uv)/ dim)+Color;
      if (pixel.y < 1 || pixel.y > openfl_TextureSize.y-1){

        bloom = vec4(0.0,0.0,0.0,1.0);
        
        }
        gl_FragColor = bloom;
    }
    ')
	public function new()
	{
        blshader = new ShaderFilter(this);
		super();
	}

    public function getFilter()
    {
        return blshader;
    }

    public function setChroma(enabled:Bool):Void
    {
        //blshader.shader.data.chromaKey.value = [enabled];
    }

    public function update(elapsed:Float)
    {
        if (blshader.shader.data.iTime.value == null)
        {   
            blshader.shader.data.iTime.value = 0;
        }
        else
        {
            blshader.shader.data.iTime.value = [blshader.shader.data.iTime.value[0] + elapsed];
        }
    }
}
