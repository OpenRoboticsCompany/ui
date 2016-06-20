-module(ui).
-author({ "David J Goehrig", "dave@dloh.org" }).
-copyright(<<"© 2016 David J Goehrig"/utf8>>).
-export([ widget/4, extent/1, lineTo/3, moveTo/3, fill/3, clear/3, foreground/5, background/5, draw/1, blank/1, path/1 ]).

widget(X,Y,W,H) ->
	[ <<"w">>, X, Y, W, H ].

extent(Widget) ->
	[ <<"w">>, X, Y, W, H | _T ] = Widget,
	{ X, Y, W, H }.

path(Widget) ->
	Widget ++ [ <<"p">> ].

lineTo(Widget,X,Y) ->
	Widget ++ [ <<"l">>, X, Y ].
	
moveTo(Widget,X,Y) ->
	Widget ++ [ <<"m">>, X, Y ].

fill(Widget,W,H) ->
	Widget ++ [ <<"f">>, W, H ].

clear(Widget,W,H) ->
	Widget ++ [ <<"c">>, W, H ].

foreground(Widget,R,G,B,A) ->
	Widget ++ [ <<"fg">>, R, G, B, A ].
	
background(Widget,R,G,B,A) ->
	Widget ++ [ <<"bg">>, R, G, B, A ].
	
draw(Widget) ->
	urelay_room:broadcast(ui_room,null,ujson:encode(Widget)).

blank(Widget) ->
	{ X, Y, W, H } = extent(Widget),
	clear(moveTo(Widget,X,Y),W,H).
	
