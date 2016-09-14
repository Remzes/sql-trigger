CREATE OR REPLACE TRIGGER Match_Making_System
BEFORE INSERT ON Particular_Player_Statistics_In_Room
REFERENCING NEW AS p
	FOR EACH ROW
		WHEN( 
			 ( 
				(SELECT 
					MAX(level_of_Account) 
						FROM Players_Account_In_Game_Information,Particular_Player_Statistics_In_Room,Server_Information
							WHERE 
								Server_Information.name_Of_Server = 'Rank Server' 
								AND Particular_Player_Statistics_In_Room.room_ID = (select MAX(room_ID) FROM Particular_Player_Statistics_In_Room)) >
				( 5 + (SELECT
						MIN(level_of_Account) 
							FROM Players_Account_In_Game_Information,Particular_Player_Statistics_In_Room, Server_Information
								WHERE 
									Server_Information.name_Of_Server = 'Rank Server' 
									AND Particular_Player_Statistics_In_Room.room_ID = (select MAX(room_ID) from Particular_Player_Statistics_In_Room)))
			 )
			OR
			 (
				(SELECT 
					MAX(rankPoints) 
						FROM Players_Account_In_Game_Information,Particular_Player_Statistics_In_Room, Server_Information
							WHERE 
								Server_Information.name_Of_Server = 'Rank Server'
								AND Particular_Player_Statistics_In_Room.room_ID = (select MAX(room_ID) FROM Particular_Player_Statistics_In_Room)) >
				( 350 + (SELECT
							MIN(rankPoints)
								FROM Players_Account_In_Game_Information,Particular_Player_Statistics_In_Room,Server_Information
									WHERE 
										Server_Information.name_Of_Server = 'Rank Server' 
										AND Particular_Player_Statistics_In_Room.room_ID = (select MAX(room_ID) FROM Particular_Player_Statistics_In_Room)))
			 )
			OR
			 (	
				(SELECT 
					MAX(K_D_rate) 
						FROM Players_Account_In_Game_Information,Particular_Player_Statistics_In_Room, Server_Information
							WHERE
								Server_Information.name_Of_Server = 'Rank Server'
								AND Particular_Player_Statistics_In_Room.room_ID = (select MAX(room_ID) FROM Particular_Player_Statistics_In_Room)) >
				( 0.05 + (SELECT 
							MIN(K_D_rate) 
								FROM Players_Account_In_Game_Information,Particular_Player_Statistics_In_Room, Server_Information
									WHERE 
									Server_Information.name_Of_Server = 'Rank Server'
									AND Particular_Player_Statistics_In_Room.room_ID = (select MAX(room_ID) FROM Particular_Player_Statistics_In_Room)))
			 )
			)
	SIGNAL SQLSTATE '72344' SET MESSAGE_TEXT = 'Big difference between statistics of players on Rank Server is impossible!';