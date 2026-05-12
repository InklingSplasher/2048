using Game2048.Core;

namespace Game2048.Tests;

public class GameBoardTests
{
    [Fact]
    public void Empty_Board_Has_No_Tiles_And_All_Cells_Are_Free()
    {
        var board = GameBoard.Empty();

        Assert.Equal(0, board.HighestTile);
        Assert.Equal(GameBoard.Size * GameBoard.Size, board.EmptyCellCount);
        Assert.True(board.HasAnyMove());
    }

    [Fact]
    public void FromCells_Copies_The_Source_Array()
    {
        var source = new int[,]
        {
            { 2, 0, 0, 0 },
            { 0, 0, 0, 0 },
            { 0, 0, 0, 0 },
            { 0, 0, 0, 0 }
        };

        var board = GameBoard.FromCells(source);
        source[0, 0] = 1024;

        Assert.Equal(2, board[0, 0]);
    }

    [Fact]
    public void FromCells_Rejects_Wrong_Size()
    {
        Assert.Throws<ArgumentException>(() => GameBoard.FromCells(new int[3, 4]));
    }

    [Fact]
    public void Move_Left_Slides_Tiles_Without_Merging_Different_Values()
    {
        var board = GameBoard.FromCells(new int[,]
        {
            { 0, 2, 0, 4 },
            { 0, 0, 0, 0 },
            { 0, 0, 0, 0 },
            { 0, 0, 0, 0 }
        });

        var result = board.Move(Direction.Left);

        Assert.True(result.Moved);
        Assert.Equal(0, result.ScoreGained);
        Assert.Equal(2, result.Board[0, 0]);
        Assert.Equal(4, result.Board[0, 1]);
        Assert.Equal(0, result.Board[0, 2]);
        Assert.Equal(0, result.Board[0, 3]);
    }

    [Fact]
    public void Move_Left_Merges_Adjacent_Equal_Tiles()
    {
        var board = GameBoard.FromCells(new int[,]
        {
            { 2, 2, 4, 4 },
            { 0, 0, 0, 0 },
            { 0, 0, 0, 0 },
            { 0, 0, 0, 0 }
        });

        var result = board.Move(Direction.Left);

        Assert.True(result.Moved);
        Assert.Equal(4 + 8, result.ScoreGained);
        Assert.Equal(8, result.HighestMerge);
        Assert.Equal(4, result.Board[0, 0]);
        Assert.Equal(8, result.Board[0, 1]);
        Assert.Equal(0, result.Board[0, 2]);
        Assert.Equal(0, result.Board[0, 3]);
    }

    [Fact]
    public void Each_Tile_May_Only_Merge_Once_Per_Move()
    {
        // [2, 2, 2, 2] left -> [4, 4, 0, 0], not [8, 0, 0, 0]
        var board = GameBoard.FromCells(new int[,]
        {
            { 2, 2, 2, 2 },
            { 0, 0, 0, 0 },
            { 0, 0, 0, 0 },
            { 0, 0, 0, 0 }
        });

        var result = board.Move(Direction.Left);

        Assert.Equal(8, result.ScoreGained);
        Assert.Equal(4, result.Board[0, 0]);
        Assert.Equal(4, result.Board[0, 1]);
        Assert.Equal(0, result.Board[0, 2]);
        Assert.Equal(0, result.Board[0, 3]);
    }

    [Fact]
    public void New_Tile_From_Merge_Cannot_Merge_Again_The_Same_Turn()
    {
        // [2, 2, 4, 0] left -> [4, 4, 0, 0]
        var board = GameBoard.FromCells(new int[,]
        {
            { 2, 2, 4, 0 },
            { 0, 0, 0, 0 },
            { 0, 0, 0, 0 },
            { 0, 0, 0, 0 }
        });

        var result = board.Move(Direction.Left);

        Assert.Equal(4, result.ScoreGained);
        Assert.Equal(4, result.Board[0, 0]);
        Assert.Equal(4, result.Board[0, 1]);
    }

    [Fact]
    public void Move_Right_Slides_And_Merges_Toward_The_Right_Edge()
    {
        var board = GameBoard.FromCells(new int[,]
        {
            { 2, 2, 0, 4 },
            { 0, 0, 0, 0 },
            { 0, 0, 0, 0 },
            { 0, 0, 0, 0 }
        });

        var result = board.Move(Direction.Right);

        Assert.Equal(4, result.ScoreGained);
        Assert.Equal(0, result.Board[0, 0]);
        Assert.Equal(0, result.Board[0, 1]);
        Assert.Equal(4, result.Board[0, 2]);
        Assert.Equal(4, result.Board[0, 3]);
    }

    [Fact]
    public void Move_Up_Slides_Along_Columns()
    {
        var board = GameBoard.FromCells(new int[,]
        {
            { 0, 0, 0, 0 },
            { 2, 0, 0, 0 },
            { 0, 0, 0, 0 },
            { 2, 0, 0, 0 }
        });

        var result = board.Move(Direction.Up);

        Assert.Equal(4, result.ScoreGained);
        Assert.Equal(4, result.Board[0, 0]);
        Assert.Equal(0, result.Board[1, 0]);
        Assert.Equal(0, result.Board[2, 0]);
        Assert.Equal(0, result.Board[3, 0]);
    }

    [Fact]
    public void Move_Down_Slides_Along_Columns()
    {
        var board = GameBoard.FromCells(new int[,]
        {
            { 2, 0, 0, 0 },
            { 0, 0, 0, 0 },
            { 2, 0, 0, 0 },
            { 0, 0, 0, 0 }
        });

        var result = board.Move(Direction.Down);

        Assert.Equal(4, result.ScoreGained);
        Assert.Equal(0, result.Board[0, 0]);
        Assert.Equal(0, result.Board[1, 0]);
        Assert.Equal(0, result.Board[2, 0]);
        Assert.Equal(4, result.Board[3, 0]);
    }

    [Fact]
    public void Move_That_Does_Not_Change_Anything_Reports_Not_Moved()
    {
        var board = GameBoard.FromCells(new int[,]
        {
            { 2, 4, 2, 4 },
            { 0, 0, 0, 0 },
            { 0, 0, 0, 0 },
            { 0, 0, 0, 0 }
        });

        var result = board.Move(Direction.Left);

        Assert.False(result.Moved);
        Assert.Equal(0, result.ScoreGained);
        Assert.Equal(board, result.Board);
    }

    [Fact]
    public void HasAnyMove_Returns_True_When_Adjacent_Equal_Tiles_Exist_On_Full_Board()
    {
        var board = GameBoard.FromCells(new int[,]
        {
            { 2, 4, 2, 4 },
            { 4, 2, 4, 2 },
            { 2, 4, 2, 4 },
            { 4, 2, 4, 4 }
        });

        Assert.Equal(0, board.EmptyCellCount);
        Assert.True(board.HasAnyMove());
    }

    [Fact]
    public void HasAnyMove_Returns_False_For_Dead_Board()
    {
        var board = GameBoard.FromCells(new int[,]
        {
            { 2, 4, 2, 4 },
            { 4, 2, 4, 2 },
            { 2, 4, 2, 4 },
            { 4, 2, 4, 2 }
        });

        Assert.False(board.HasAnyMove());
    }

    [Fact]
    public void WithSpawnedTile_Places_Value_At_Nth_Empty_Cell()
    {
        var board = GameBoard.FromCells(new int[,]
        {
            { 2, 0, 0, 0 },
            { 0, 0, 0, 0 },
            { 0, 0, 0, 0 },
            { 0, 0, 0, 0 }
        });

        var spawned = board.WithSpawnedTile(emptyCellIndex: 2, value: 4);

        Assert.Equal(2, spawned[0, 0]);
        Assert.Equal(0, spawned[0, 1]);
        Assert.Equal(0, spawned[0, 2]);
        Assert.Equal(4, spawned[0, 3]);
    }

    [Fact]
    public void Move_Does_Not_Mutate_Original_Board()
    {
        var board = GameBoard.FromCells(new int[,]
        {
            { 2, 2, 0, 0 },
            { 0, 0, 0, 0 },
            { 0, 0, 0, 0 },
            { 0, 0, 0, 0 }
        });

        _ = board.Move(Direction.Left);

        Assert.Equal(2, board[0, 0]);
        Assert.Equal(2, board[0, 1]);
    }
}
