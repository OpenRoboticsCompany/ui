-module(ui_bargraph).
-author({ "David J Goehrig", "dave@dloh.org" }).
-copyright(<<"© 2016 David J Goehrig"/utf8>>).

-export([draw/7]).

plot(Widget, [], _X, _Y, _Dx, _Dy, _Dm) ->
	Widget;

plot(Widget,[D|Ds],X,Y,Dx,Dy,Dm) ->
	W = ui:moveTo(Widget, round(X+Dx), round(Y)),
	Ws = ui:fill(W, Dx, round(Dy*(D-Dm))),
	plot(Ws,Ds,X+Dx,Y,Dx,Dy,Dm).

draw(X,Y,W,H,S,R,[ D | Ds ] = Data) ->
	Wb = ui_graph:bounds([],X,Y,W,H),
	Wh = ui_graph:hashes(Wb,X,Y,W,H,S,R),
	Dx = W / length(Data),
	Dmin = 0,
	Dmax = lists:foldl(fun(A,B) -> max(A,B) end, D, Ds ), 
	Dy = H / (Dmax - Dmin),	
	plot(Wh, [ D | Ds ],X - Dx,Y,Dx,Dy,Dmin).
	

