local AI = {guesses = {"Rock", "Paper", "Scissors"}}

function AI:calculate()
	local function guessChoice()
		return self.guesses[math.random(1, #self.guesses)]
	end
	
	local userInput = self.guesses[io.read()]
	local botInput = guessChoice()
	
	local outcomes = {
		[1] = {[1]="Rock",[2]="Paper",["outcome"]=false};
		[2] = {[1]="Paper",[2]="Rock",["outcome"]=true};
		[3] = {[1]="Scissors",[2]="Paper",["outcome"]=true};
		[4] = {[1]="Paper",[2]="Scissors",["outcome"]=false};
		[5] = {[1]="Rock",[2]="Scissors",["outcome"]=true};
		[6] = {[1]="Scissors",[2]="Rock",["outcome"]=false};
	}
	
	local function getOutcome()
		for k, v in pairs(outcomes) do
			if v[1] == userInput and v[2] == botInput then
				if v.outcome == true then
					return true
				end
				return false
			end
		end
	end
	
	return getOutcome()
end
