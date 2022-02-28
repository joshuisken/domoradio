# Create Internet radio buttons in Domoticz

Using the [python notebook](file:Domo_InternetRadio_selector.ipynb)
you can configure selector buttons in domoticz which allow you to stream
internet radio stations. In my case domoticz is running on a Raspberry
Pi 3 which is connected to an audio amplifier using HDMI.

In the notebook you can find three parts:

1. collect urls for internet radio streams using regexes
2. specification of selector switches in domoticz which allow
   selection of radio stations
3. domoticz [lua script](file:radio.lua), which needs to be modified
   for your own situation

