package merge;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import org.springframework.stereotype.Component;

@Component
public class Spell {
	
	public String spellMerge(String msg){
		String[] msgs = msg.split("");
		String temp = "";
		String result = "";
		for(int i=0; i<msgs.length; i++){
			String str = msgs[i];
			if(!temp.equals(str)){
				temp = str;
				result += str;
			}
		}
		return result;
	}
	
	public String wordMerge(String msg){
		String result = msg;
		
		// 길이검사
		if(msg.length() > 7) {
			result ="";
			// 띄어쓰기 검사
			String[] words = msg.split("\\s");
			
			String temp = "";
			
			for(int i=0; i<words.length; i++){
				// 첫글자 막글자 검사법
				String newWord = this.word(words[i]);
				
				if(!temp.equals(newWord)) {
					// System.out.println(words[i] +"==>>" + newWord);
					if((words[i].length() - newWord.length()) > 1) result += newWord+" "; else result += words[i]+" ";
					temp = newWord;
				} 
			}
			
			
		}
		
		// System.out.println(result);
		return result.trim();
	}
	
	// 단어와 단어 축약법
	public void wordByword(){
		
	}
	
	// 첫글자 막글자 검사법
	public static String word(String word){
		String result = "";
		List<Integer> list = new ArrayList<Integer>();
		
		for(int i=0; i<word.length(); i++){
			char ch =  word.charAt(i);
			int lastIndex = word.lastIndexOf(ch);
			if(!list.contains(lastIndex)) list.add(lastIndex);
		}
		Collections.sort(list);
		for(int i=0; i<list.size(); i++){
			result += word.charAt(list.get(i));
		}
		return result;
	}
	
}
