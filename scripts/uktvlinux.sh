#!/bin/sh
#Hawkeye34's British TV Shell Script
#Version 1.53 (first release, 53 channels)
#Written on 19 March 2010 for myp2pforum.eu
#Looking for live sport schedules? Visit myp2p.eu | myp2p.us | myp2p.nl
echo "British TV for Linux! | Hawkeye34 - myp2pforum.eu | Version 1.53: 19 March 2010"
#!!DO NOT EDIT AFTER THIS POINT UNLESS YOU KNOW WHAT YOU ARE DOING!!
echo -e "1. BBC1\t\t\t23. History\t\t\t45. ITV1 (LQ)"
echo -e "2. BBC2\t\t\t24. Discovery\t\t\t46. ITV2 (LQ)"
echo -e "3. ITV1\t\t\t25. Movies 1\t\t\t47. ITV3 (LQ)"
echo -e "4. Channel 4\t\t26. Movies 2\t\t\t48. CBS Reality (LQ)"
echo -e "5. Five\t\t\t27. Movies 3\t\t\t49. BBC News24 (LQ)"
echo -e "6. BBC3\t\t\t28. Movies 4\t\t\t50. Bloomberg (LQ)"
echo -e "7. BBC4\t\t\t29. Eurosport\t\t\t51. Deutsche Welle"
echo -e "8. ITV2\t\t\t30. BBC News24\t\t\t52. CNN International"
echo -e "9. ITV3\t\t\t31. Sky News\t\t\t53. CNN Int'l (LQ)"
echo -e "10. ITV4\t\t32. Sky News Headlines"
echo -e "11. E4\t\t\t33. BBC Parliament"
echo -e "12. More4\t\t34. Bloomberg TV"
echo -e "13. CBS Reality\t\t35. Russia Today"
echo -e "14. 4Music\t\t36. Scuzz"
echo -e "15. Zone Horror\t\t37. Flaunt"
echo -e "16. Film4\t\t38. France 24"
echo -e "17. Classic Movies2\t39. BBC1 (LQ)"
echo -e "18. James Bond TV\t40. BBC2 (LQ)"
echo -e "19. QVC\t\t\t41. BBC3 (LQ)"
echo -e "20. S4C\t\t\t42. C4 (LQ)"
echo -e "21. Fashion TV\t\t43. E4 (LQ)"
echo -e "22. ClassicFM TV\t44. Five (LQ)"
echo -n "Please enter a channel number: "
read chnum
#Begin VLC commands. 
case $chnum in
	
	"1") echo "Starting BBC1..."
	mplayer http://cctv.ws/7/BBC1 ;;

	"2") echo "Starting BBC2..."
	mplayer http://cctv.ws/7/BBC2 ;;
	
	"3") echo "Starting ITV1..."
	mplayer http://cctv.ws/2/ITV1 ;;

	"4") echo "Starting Channel Four..."
	mplayer http://cctv.ws/5/ChannelFour ;;
	
	"5") echo "Starting Five..."
	mplayer http://cctv.ws/0/s3byz/Five ;; 
	
	"6") echo "Starting BBC3..."
	mplayer http://cctv.ws/9/BBC3 ;;

	"7") echo "Starting BBC4..."
	mplayer http://cctv.ws/7/CBeebies/BBC4 ;;

	"8") echo "Starting ITV2..."
	mplayer http://cctv.ws/0/NhYpi4/ITV2 ;;

	"9") echo "Starting ITV3..."
	mplayer http://cctv.ws/0/ITV3 ;;

	"10") echo "Starting ITV4..."
	mplayer http://cctv.ws/3/rrU5j/ITV4 ;;

	"11") echo "Starting E4..."
	mplayer http://cctv.ws/5/E4Channel ;;

	"12") echo "Starting More4..."
	mplayer http://cctv.ws/3/More4 ;;

	"13") echo "Starting CBS Reality..."
	mplayer http://cctv.ws/6/CBSReality ;;

	"14") echo "Starting 4Music..."
	mplayer http://cctv.ws/3/4Music ;;

	"15") echo "Starting Zone Horror..."
	mplayer http://cctv.ws/1/ZoneHorror ;;

	"16") echo "Starting Film4..."
	mplayer http://cctv.ws/1/3eZ1R1/Film4 ;;

	"17") echo "Starting Classic Movies2..."
	mplayer http://cctv.ws/4/classicmovies2 ;;

	"18") echo "Starting James Bond TV..."
	mplayer http://cctv.ws/2/JamesBondTV ;;
	
	"19") echo "Starting QVC..."
	mplayer http://cctv.ws/2/qvcuk ;;

	"20") echo "Starting S4C..."
	mplayer mms://cctv.ws/7/S4Cdigidol ;;

	"21") echo "Starting Fashion TV..."
	mplayer http://cctv.ws/0/FashionTV ;;

	"22") echo "Starting ClassicFM TV..."
	mplayer http://cctv.ws/6/cfmtv ;;

	"23") echo "Starting History..."
	mplayer http://cctv.ws/9/1wbeA4/History ;;

	"24") echo "Starting Discovery..."
	mplayer http://cctv.ws/9/DiscoveryChannel ;;
	
	"25") echo "Starting Movies 1..."
	mplayer http://cctv.ws/7/somethingmovies1 ;;

	"26") echo "Starting Movies 2..."
	mplayer http://cctv.ws/9/somethingmovies2 ;;

	"27") echo "Starting Movies 3..."
	mplayer http://cctv.ws/1/somethingmovies3 ;;

	"28") echo "Starting Movies 4..."
	mplayer http://cctv.ws/2/ovies3 ;; #Yes, this is the right channel. cctv.ws was having issues.

	"29") echo "Starting Eurosport..."
	mplayer http://cctv.ws/1/BritishEurosport ;;
	
	"30") echo "Starting BBC News24..."
	mplayer http://cctv.ws/8/BBCNews ;;

	"31") echo "Starting Sky News..."
	mplayer http://cctv.ws/2/SkyNews ;;

	"32") echo "Starting Sky News Headlines..."
	mplayer mms://live1.wm.skynews.servecast.net/skynews_wmlz_live300k ;;

	"33") echo "Starting BBC Parliament..."
	mplayer http://cctv.ws/5/bbcpar ;;

	"34") echo "Starting Bloomberg TV..."
	mplayer http://cctv.ws/6/BloombergUK ;;

	"35") echo "Starting Russia Today..."
	mplayer http://cctv.ws/9/RussiaToday ;;
	
	"36") echo "Starting Scuzz..."
	mplayer http://cctv.ws/1/Scuzz ;;

	"37") echo "Starting Flaunt..."
	mplayer http://cctv.ws/3/Flaunt ;;

	"38") echo "Starting France 24..."
	mplayer http://cctv.ws/6/France24En ;;

	"39") echo "Starting BBC1 (LQ)..."
	mplayer http://cctv.ws/6/BBC1LQ ;;

	"40") echo "Starting BBC2 (LQ)..."
	mplayer http://cctv.ws/1/BBC2LQ ;;

	"41") echo "Starting BBC3 (LQ)..."
	mplayer http://cctv.ws/5/BBC3lq ;;

	"42") echo "Starting Channel Four (LQ)..."
	mplayer http://cctv.ws/3/C4LQ ;;

	"43") echo "Starting E4 (LQ)..."
	mplayer http://cctv.ws/1/e4lQ ;;

	"44") echo "Starting Five (LQ)..."
	mplayer http://cctv.ws/1/FivelQ ;;

	"45") echo "Starting ITV1 (LQ)..."
	mplayer http://cctv.ws/3/ITV1LQ ;;

	"46") echo "Starting ITV2 (LQ)..."
	mplayer http://cctv.ws/8/TV2lq/ITV2LQ ;;

	"47") echo "Starting ITV3 (LQ)..."
	mplayer http://cctv.ws/4/ITV3LQ ;;

	"48") echo "Starting CBS Reality (LQ)..."
	mplayer http://cctv.ws/4/CBSRealityLQ ;;

	"49") echo "Starting BBC News24 (LQ)..."
	mplayer http://cctv.ws/3/BBCnewsLQ ;;

	"50") echo "Starting Bloomberg (LQ)..."
	mplayer http://cctv.ws/8/BloombergLQ ;;

	"51") echo "Die Deutsche Welle startet..."
	mplayer http://cctv.ws/0/DeutscheWelle ;;

	"52") echo "Starting CNN International..."
	mplayer http://cctv.ws/7/CNNint ;;

	"53") echo "Starting CNN International (LQ)..."
	mplayer http://cctv.ws/5/xvtmX3/CNNlq ;;

	"*") echo "Sorry, channel $chnum does not exist at the moment. Please make sure you entered a NUMBER, not a NAME. You can also try checking myp2pforum.eu for an updated version of this script.";;
	

esac
	



	



