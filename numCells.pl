%Same as above, but faster, as it uses a formula directly.
numPieces( Num, Size ) :-
	Num is round( (Size*Size-Size)*3/2 ).

%Fills a given line with a random number of crosses and circles.
fillLine( [], [], X, O, X, O ). %End of line reached.
fillLine( [0], [0], 0, 0, 0, 0 ). %End of random elements reached. (Final piece of the board.)

fillLine( [_|LT], [RLH|RLT], NumCross, 0, RCross, 0 ) :- %All Circles have been set already.
	RLH is 1, %Current element is an X (1).
	NewCross is NumCross-1, %Decrement number of Crosses.
	fillLine( LT, RLT, NewCross, 0, RCross, 0 ). %Recursive call.

fillLine( [_|LT], [RLH|RLT], 0, NumCircle, 0, RCircle ) :- %All Crosses have been set already.
	RLH is 2, %Current element is an O (2).
	NewCircle is NumCircle-1, %Decrement number of Circles.
	fillLine( LT, RLT, 0, NewCircle, 0, RCircle ). %Recursive call.

fillLine( [_|LT], [RLH|RLT], NumCross, NumCircle, RCross, RCircle ) :- %Both NumCross and NumCircle are higher than 0.
	random( 0, 2, R ), %R = [0,1]; ( [0,2[ )
	NewCross is NumCross-(1-R), %R=0 -> NewCross = NumCross-1; R=1 -> NewCross = NumCross
	NewCircle is NumCircle-R, %R=0 -> NewCircle = NumCircle; R=1 -> NewCircle = NumCircle-1
	RLH is 1+R, %Set the current element to either an X (1) or an O (2).
	fillLine( LT, RLT, NewCross, NewCircle, RCross, RCircle ). %Recursive call.

%Fills the Board with the given number of Cross and Circle pieces.
fillBoard( [], [], 0, 0 ). %End case. We reach the end of the Board, and we have no more Crosses nor Circles left to add.

fillBoard( [BH|BT], [RBH|RBT], NumCross, NumCircle ) :-
	fillLine( BH, RBH, NumCross, NumCircle, NewCross, NewCircle ), %Fill the current Line of the Board.
	fillBoard( BT, RBT, NewCross, NewCircle ). %Recursive call.
