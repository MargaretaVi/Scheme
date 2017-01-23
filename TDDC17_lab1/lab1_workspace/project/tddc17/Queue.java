package tddc17;
import java.util.*;

import aima.core.agent.Action;
import aima.core.agent.impl.NoOpAction;
import aima.core.environment.liuvacuum.*;

public class Queue {
	private Vector <Integer> commandQueue;
	
	Queue(){
		commandQueue=new Vector<Integer>();
	}
	
	public Boolean hasNext(){
		return !commandQueue.isEmpty();
	}
	
	public int getNext(){
		int fetchTmp = commandQueue.firstElement();
		commandQueue.remove(0);
		switch(fetchTmp){
			case 1:
				return 2;
			case 2:
				return 1;
			case 3:
				return 0;
			}
		return 7; // ska inte hända :)
		}
	public void addCommandSequence(int[] seq){
		for(int i=seq.length-1; i>=0;i--){
			commandQueue.add(0, seq[i]);
		}
	}
	public int getNumberOfCommands(){
		return commandQueue.size();
	}
	public void clearQueue(){
		commandQueue.clear();
	}
	
}