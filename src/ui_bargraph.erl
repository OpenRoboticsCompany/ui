-module(ui_bargraph).
-author({ "David J Goehrig", "dave@dloh.org" }).
-copyright(<<"© 2016 David J Goehrig"/utf8>>).

-export([draw/6]).

plot(Widget, [], _X, _Y, _Dx, _Dy, _Dm) ->
	Widget;
plot(Widget,[{{R,G,B,A}, D}|Ds],X,Y,Dx,Dy,Dm) ->
	Wp = ui:path(Widget),
	Wc = ui:foreground(Wp,R,G,B,A),
	Wm = ui:moveTo(Wc, round(X+(Dx/2)+Dx), round(Y)),
	Ws = ui:fill(Wm, round(Dx/2), round(Dy*(D-Dm))),
	plot(Ws,Ds,X+Dx,Y,Dx,Dy,Dm).

limits([],Max) ->
	Max;
limits([ { _, D } | Ds ], Max) ->
	limits(Ds, max(D,Max)).

draw(X,Y,W,H,{ {Rb,Gb,Bb,Ab},S,R },Data) ->
	Wp = ui:path([]),
	Wc = ui:foreground(Wp,Rb,Gb,Bb,Ab),	
	Wb = ui_graph:bounds(Wc,X,Y,W,H),
	Wh = ui_graph:hashes(Wb,X,Y,W,H,S,R),
	Dx = W / length(Data),
	Dmin = 0,
	Dmax =  limits(Data,0),
	Dy = H / (Dmax - Dmin),	
	Wg = plot(Wh, Data, X - Dx,Y,Dx,Dy,Dmin),
	ui:path(Wg).
	

