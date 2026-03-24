# Terminal
## Kitty 
To make nvim colors work nicely

## LSCOLOR
Using vivid plugin to set color themes, run in the terminal 

## ZSH
powerlevel10k plugin for theme generation

# Keymap
Using setxkbmap works when the system is already loaded, but setting the default keyboard (/etc/default/keyboard) and/or system settings (cinnamon-settings in my case with Mint)
It turns out that ibus is used, and ibus-setup works for any normal keyboard. But I could not make it detect my custom keymap. 
In the end I could tell ibus to use the system keymap instead, which made it not override my setting

## Custom keymap
see keymap/se, this contains the normal keymap file found with my version of x11. Maybe you need to merge the ma_dvorak part into another dist, as well as the lst and xml files. Im unsure how alike they are. Best case you can directly use the se-file and overwrite the one in /usr/share/X11/xkb/symbols, the same with the lst and xml file that should be placed in /usr/share/X11/xkb/rules/

### xkb events and name
The keyboard key names follow an ISO standard, and you can find the names of the characters by using 'xev', that will print the event and character mapped to a key. You need to use an existing keymap for that to work however
