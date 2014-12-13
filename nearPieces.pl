%Checks if two Pieces are the same and sets the last argument to 1 if so, 0 otherwise.
samePiece( Piece, Piece, 1 ). %If they're the same, stop right here and the last argument is 1.
samePiece( _, _, 0 ). %Otherwise, anything else that they are, they won't be the same and the last argument can be 0 safely.

%Checks how many pieces above the given piece and adjancent to it are the same as itself.
numAbove( Board, Line, Col, Num ) :-
	getSize( Board, Size ), %Get the Size for comparison.
	((Line < Size+1, %If Line<Size (we're not midway through the board)
		UpLeft is Col-1); %Then UpLeft = Col-1.
	 UpLeft is Col), %Else UpLeft = Col.
	UpRight is UpLeft+1, %UpRight = UpLeft+1.
	AboveLine is Line-1, %The Line above ours.
	getPiece( Board, Line, Col, StartPiece ), %Get our own piece.
	getPiece( Board, AboveLine, UpLeft, ULPiece ), %Get the piece above and to the left.
	getPiece( Board, AboveLine, UpRight, URPiece ), %Get the piece above and to the right.
	samePiece( StartPiece, ULPiece, TmpNum ), %(StartPiece==ULPiece) + ...
	samePiece( StartPiece, URPiece, TmpNum2 ), %... + (StartPiece==URPiece) = ...
	Num is TmpNum+TmpNum2. %... = Num.

%Checks how many pieces under the given piece and adjancent to it are the same as itself.
numUnder( Board, Line, Col, Num ) :-
	getSize( Board, Size ), %Get the Size for comparison.
	((Line < Size, %If Line<Size (we're not midway through the board)
		DownLeft is Col); %Then DownLeft = Col.
	 DownLeft is Col-1), %Else DownLeft = Col-1.
	DownRight is DownLeft+1, %DownRight = DownLeft+1.
	UnderLine is Line+1, %The Line under ours.
	getPiece( Board, Line, Col, StartPiece ), %Get our own piece.
	getPiece( Board, UnderLine, DownLeft, DLPiece ), %Get the piece under and to the left.
	getPiece( Board, UnderLine, DownRight, DRPiece ), %Get the piece under and to the right.
	samePiece( StartPiece, DLPiece, TmpNum ), %(StartPiece==DLPiece) + ...
	samePiece( StartPiece, DRPiece, TmpNum2 ), %... + (StartPiece==DRPiece) = ...
	Num is TmpNum+TmpNum2. %... = Num.

%Checks how many pieces in the same line as the given piece and adjacent to it are the same as itself.
numSameLine( Board, Line, Col, Num ) :-
	LCol is Col-1, %LCol = Col-1.
	RCol is Col+1, %Rcol = Col+1.
	getPiece( Board, Line, Col, StartPiece ), %Get our own piece.
	getPiece( Board, Line, LCol, LPiece ), %Get the piece to the left.
	getPiece( Board, Line, RCol, RPiece ), %Get the piece to the right.
	samePiece( StartPiece, LPiece, TmpNum ), %(StartPiece==LPiece) + ...
	samePiece( StartPiece, RPiece, TmpNum2 ), %... + (StartPiece==RPiece) = ...
	Num is TmpNum+TmpNum2. %... = Num.

%Gets the number of pieces adjacent to the given piece.
numNearPiece( Board, Line, Col, Num ) :-
	numAbove( Board, Line, Col, N1 ), %N1 + ...
	numSameLine( Board, Line, Col, N2 ), %... + N2 + ...
	numUnder( Board, Line, Col, N3 ), %... + N3 = ...
	Num is N1+N2+N3. %... = Num.
