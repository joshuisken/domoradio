--
-- This script play a streaming radio when the device is changed
-- Start files with "mplayer -noconsolecontrols radiostation.mp3 &> /dev/null"
-- Start playlists with "mplayer -noconsolecontrols -playlist radiostation.m3u &> /dev/null"
--
-- For radiostations see: https://www.hendrikjansen.nl/henk/streaming.html
--

local stations = {
   ['NPO Radio 1'] = 'https://icecast.omroep.nl/radio1-bb-mp3',
   ['NPO Radio 2'] = 'https://icecast.omroep.nl/radio2-bb-mp3',
   ['NPO Radio 2 Soul & Jazz'] = 'https://icecast.omroep.nl/radio6-bb-mp3',
   ['NPO 3FM'] = 'https://icecast.omroep.nl/3fm-bb-mp3',
   ['NPO 3FM Alternative'] = 'https://icecast.omroep.nl/3fm-alternative-mp3',
   ['NPO 3FM KX Radio'] = 'https://icecast.omroep.nl/3fm-serioustalent-mp3',
   ['NPO Radio 4'] = 'https://icecast.omroep.nl/radio4-bb-mp3',
   ['NPO Radio 4 Concerten'] = 'https://icecast.omroep.nl/radio4-eigentijds-mp3',
   ['NPO Radio 5'] = 'https://icecast.omroep.nl/radio5-bb-mp3',
   ['NPO Radio 1'] = 'https://icecast.omroep.nl/radio1-bb-mp3',
   ['NPO Radio 2'] = 'https://icecast.omroep.nl/radio2-bb-mp3',
   ['NPO Radio 2 Soul & Jazz'] = 'https://icecast.omroep.nl/radio6-bb-mp3',
   ['NPO 3FM'] = 'https://icecast.omroep.nl/3fm-bb-mp3',
   ['NPO 3FM Alternative'] = 'https://icecast.omroep.nl/3fm-alternative-mp3',
   ['NPO 3FM KX Radio'] = 'https://icecast.omroep.nl/3fm-serioustalent-mp3',
   ['NPO Radio 4'] = 'https://icecast.omroep.nl/radio4-bb-mp3',
   ['NPO Radio 4 Concerten'] = 'https://icecast.omroep.nl/radio4-eigentijds-mp3',
   ['NPO Radio 5'] = 'https://icecast.omroep.nl/radio5-bb-mp3',
   ['NPO Radio 4'] = 'https://icecast.omroep.nl/radio4-bb-mp3',
   ['NPO Radio 4 Concerten'] = 'https://icecast.omroep.nl/radio4-eigentijds-mp3',
   ['Klara'] = 'http://icecast.vrtcdn.be/klara-high.mp3',
   ['Klara Continuo'] = 'http://icecast.vrtcdn.be/klaracontinuo-high.mp3',
   ['Classic FM'] = 'http://media-ice.musicradio.com/ClassicFM',
   ['Classic FM Hall of Fame'] = 'http://media-ice.musicradio.com/ClassicFM-M-Top100',
   ['Klassik Radio - Live'] = 'https://klassikr.streamabc.net/klassikradio-simulcast-mp3-mq',
   ['BR-Klassik'] = 'https://dispatcher.rndfnk.com/br/brklassik/live/mp3/high',
   ['Sublime Live'] = 'https://playerservices.streamtheworld.com/api/livestream-redirect/SUBLIME.mp3',
   ['Arrow Classic Rock'] = 'https://stream.player.arrow.nl/arrow',
   ['Sky Radio 101 FM'] = 'https://19993.live.streamtheworld.com/SKYRADIO.mp3',
   ['Sky Smooth Hits'] = 'https://20403.live.streamtheworld.com/SRGSTR15.mp3',
   ['NPO 3FM'] = 'https://icecast.omroep.nl/3fm-bb-mp3',
   ['538'] = 'https://21253.live.streamtheworld.com/RADIO538.mp3',
   ['Qmusic Nederland'] = 'https://stream.qmusic.nl/qmusic/aachigh',
   ['538'] = 'https://21253.live.streamtheworld.com/RADIO538.mp3',
   ['Slam! 40'] = 'https://stream.slam.nl/web14_mp3',
   ['Arrow Rock Radio'] = 'https://stream.arrowcaz.nl/arrowrockradio',
   ['BBC Radio 1'] = 'https://stream.live.vc.bbcmedia.co.uk/bbc_radio_one',
   ['Radio 1'] = 'http://icecast.vrtcdn.be/radio1-high.mp3',
   ['Radio 1 LageLandenLijst'] = 'https://live-radio-cf-vrt.akamaized.net/groupc/live/4023dbf7-2934-459c-8ded-f91619f58df5/live.isml/live-audio=128000.m3u8',
   ['NPO Radio 2 Soul & Jazz'] = 'https://icecast.omroep.nl/radio6-bb-mp3',
   ['Sublime Jazz'] = 'https://playerservices.streamtheworld.com/api/livestream-redirect/SUBLIMEPUREJAZZ.mp3',
   ['Arrow Bluesbox Radio - ABR)'] = 'https://stream.arrowcaz.nl/bluesboxonline',
   ['Sky Lounge'] = 'https://playerservices.streamtheworld.com/api/livestream-redirect/SRGSTR07.mp3',
   ['Classic 21 Blues'] = 'https://radios.rtbf.be/wr-c21-blues-128.mp3',
   ['Sublime Soul'] = 'https://playerservices.streamtheworld.com/api/livestream-redirect/SUBLIMESOUL.mp3',
}


return {
   active = true,
   on = {
      devices = {
	 'Beats Radio',
	 'Radio *',
      }
   },
   execute = function(dz, selector)
      local selectors = {'Beats Radio', 'Radio Blues Jazz Soul', 'Radio Elize',
			 'Radio Jeroen', 'Radio Klassiek', 'Radio NPO'}
      if (selector.state == 'Off') then
	 -- Kill all mplayers (that's why starting mplayer needs to be delayed)
	 os.execute("killall mplayer")
	 print('PRadio Off: ' .. selector.state)
	 dz.log('Radio Off: ' .. selector.state)
      else
	 -- Switch Onkyo on
	 if (dz.devices('Onkyo Master power').state == 'Off') then
	    dz.devices('Onkyo Master power').switchOn()
	 end
	 -- Switch Onkyo to CBL/SAT
	 if (dz.devices('Onkyo Master selector').levelVal ~= 10) then
	    dz.devices('Onkyo Master selector').switchSelector(10)
	 end
	 -- If coming from Bluetooth playing, lower volume
	 if (dz.devices('Onkyo Master volume').level >= 50) then
	    dz.devices('Onkyo Master volume').setLevel(20)
	    print('PRadio: setting Onkyo volume to 20')
	 end
	 -- Switch other Radio devices 'off' in gui
	 for i,s in pairs(selectors) do
	    if ((s ~= selector.name) and (dz.devices(s).state ~= 'Off')) then
	       dz.devices(s).switchOff()
	       -- dz.devices(s).setState('Off')  -- Seems equivalent
	       print('Off, but not yet: ' .. s)
	    end
	 end
	 print('PRadio: ' .. selector.state .. '\t' .. stations[selector.state])
	 dz.log('Radio: ' .. selector.state)
	 -- Need to wait since another radio selector may still be switched off
         os.execute("(killall mplayer; sleep 1; mplayer -noconsolecontrols ".. stations[selector.state] ..") &> /dev/null")
      end
   end
}
