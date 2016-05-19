-module(ui_linegraph).
-author({ "David J Goehrig", "dave@dloh.org" }).
-copyright(<<"© 2016 David J Goehrig"/utf8>>).

-export([draw/7]).

plot(Widget, [], _X, _Y, _Dx, _Dy, _Dm) ->
	Widget;

plot(Widget,[D|Ds],X,Y,Dx,Dy,Dm) ->
	W = ui:lineTo(Widget, round(X+Dx), round(Y + Dy*(D-Dm))),
	plot(W,Ds,X+Dx,Y,Dx,Dy,Dm).

draw(X,Y,W,H,S,R,[ D | Ds ] = Data) ->
	Wb = ui_graph:bounds([],X,Y,W,H),
	Wh = ui_graph:hashes(Wb,X,Y,W,H,S,R),
	Dx = W / length(Data),
	Dmin = lists:foldl(fun(A,B) -> min(A,B) end, D, Ds ), 
	Dmax = lists:foldl(fun(A,B) -> max(A,B) end, D, Ds ), 
	Dy = H / (Dmax - Dmin),	
	Ws = ui:moveTo(Wh,X,Y + round(Dy*(D - Dmin))),
	plot(Ws, Ds,X,Y,Dx,Dy,Dmin).

