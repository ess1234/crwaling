package merge;

import java.util.HashMap;
import java.util.LinkedList;
import java.util.Map;
import java.util.Queue;

import org.springframework.stereotype.Component;

@Component
public class RealTime {
	
	final int SCOPE = 21; 
	private int idx = 1;
	private Queue<String> Q = new LinkedList<String>();
	private HashMap<String, Integer> seq = new  HashMap<String, Integer>();
	
	// offer 저장, peek 읽기, poll 꺼내기
	public Map offerSentence(String msg){
		HashMap<String, Integer> result = new HashMap<String, Integer>();
		// int result = idx;
		// 20 개 
		if(Q.size() > SCOPE) seq.remove(Q.poll());
		
		if(!Q.contains(msg)){
			Q.offer(msg);
			result.put("seq", idx);
			seq.put(msg, idx++);
		} else {
			result.put("duplicate", seq.get(msg));
		}
		return result;
	}
	
	public void flush(){
		Q.clear();
	}

}
