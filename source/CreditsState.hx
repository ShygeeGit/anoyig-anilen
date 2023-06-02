package;

import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.util.FlxColor;
import flash.text.TextField;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import lime.utils.Assets;
import flixel.FlxSprite;
import flixel.FlxG;

#if desktop
import Discord.DiscordClient;
#end
#if MODS_ALLOWED
import sys.FileSystem;
import sys.io.File;
#end

using StringTools;

class CreditsState extends MusicBeatState {
	var colorTween:FlxTween;

	var bg:FlxSprite;
	var imgLogo:FlxSprite;
	var lblQuote:New_Alphabet;
	var imgCharacter:FlxSprite;
	var lblDescription:New_Alphabet;

	var creditStuff:Array<Dynamic> = [
		{name: "postroff", color: 0xffffffff},
		{name: "hev", color: 0xffffffff},
		{name: "goodiebag", color: 0xffffffff},
		{name: "grimlock", color: 0xffffffff},
		{name: "shygee", color: 0xffffffff}
	];

	var curSelected = 0;
	override function create(){
		persistentUpdate = true;
		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		bg = new FlxSprite().loadGraphic(Paths.image('menuDesat')); add(bg);
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		bg.screenCenter();

		imgCharacter = new FlxSprite(25, 25); add(imgCharacter);
		imgCharacter.antialiasing = ClientPrefs.globalAntialiasing;
		imgLogo = new FlxSprite(0, 25); add(imgLogo);
		imgLogo.antialiasing = ClientPrefs.globalAntialiasing;

		lblDescription = new New_Alphabet(0, 0, [{text: "Placeholder"}]); add(lblDescription);
		lblQuote = new New_Alphabet(0, 100, [{text: "Placeholder"}]); add(lblQuote);

		super.create();
		changeSelection();
	}

	var holdTime:Float = 0;
	var quitting:Bool = false;
	override function update(elapsed:Float){
		if (FlxG.sound.music.volume < 0.7){FlxG.sound.music.volume += 0.5 * FlxG.elapsed;}

		if(!quitting){
			if(controls.BACK){
				if(colorTween != null){colorTween.cancel();}
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new MainMenuState());
				quitting = true;
			}
			if(controls.UI_LEFT_P){changeSelection(-1);}
			if(controls.UI_RIGHT_P){changeSelection(1);}
		}
		
		super.update(elapsed);
	}

	var moveTween:FlxTween = null;
	function changeSelection(change:Int = 0, force:Bool = false){
		curSelected += change; if(force){curSelected = change;}
		if(curSelected >= creditStuff.length){curSelected = 0;}
		if(curSelected < 0){curSelected = creditStuff.length - 1;}

		if(colorTween != null){colorTween.cancel();}

		var cur_credit = creditStuff[curSelected];

		imgCharacter.loadGraphic(Paths.image('credits/${cur_credit.name.toLowerCase()}_credits_render'));
		imgCharacter.setGraphicSize(0, FlxG.height - 50); imgCharacter.updateHitbox();
		imgCharacter.setPosition(25, 25);

		var last_width:Float = imgCharacter.x + imgCharacter.width + 25;
		var logo_width:Float = FlxG.width - last_width;

		imgLogo.loadGraphic(Paths.image('credits/${cur_credit.name.toLowerCase()}_logo'));
		imgLogo.setGraphicSize(0, 150); imgLogo.updateHitbox();
		imgLogo.setPosition(last_width + (logo_width / 2) - (imgLogo.width / 2), 25);

		lblDescription.cur_data = CoolUtil.getLangText('credit_description_${cur_credit.name.toLowerCase()}'); lblDescription.loadText();
		lblDescription.setPosition(last_width, imgLogo.y + imgLogo.height + 25);

		lblQuote.cur_data = CoolUtil.getLangText('credit_quote_${cur_credit.name.toLowerCase()}'); lblQuote.loadText();
		lblQuote.setPosition(last_width + (logo_width / 2) - (lblQuote.width / 2), imgCharacter.y + imgCharacter.height - lblQuote.height);

		//colorTween = FlxTween.tween(bg, {color: creditStuff[change].color}, 1, {onComplete: function(twn:FlxTween){colorTween.destroy();}});
	}
}