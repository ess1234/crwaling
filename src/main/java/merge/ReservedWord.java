package merge;

import java.util.Stack;

import org.springframework.stereotype.Component;

@Component
public class ReservedWord {
	final String[] reservedLaugh = {"ㅋ","ㅋㅋ","ㅋㅋㅋ","ㅋㅋㅋㅋ","ㅋㅋㅋㅋㅋ","ㅋㅋㅋㅋㅋㅋ","ㅋㅋㅋㅋㅋㅋㅋ","ㅋㄷ","크크크","ㅋ욱겨","ㅋ개욱겨","욱겨","개욱겨"};
	final Stack<String> reservedLaughWord = new Stack<String>();
	
	final String[] reservedSmile = {"ㅎ","ㅎㅎ","ㅎㅎㅎ","ㅎㅎㅎㅎ","ㅎㅎㅎㅎㅎ","ㅎㅎㅎㅎㅎㅎ","ㅎㅎㅎㅎㅎㅎㅎ","아하하"};
	final Stack<String> reservedSmileWord = new Stack<String>();
	
	final String[] reservedCry = {"ㅠ","ㅠㅠ","ㅠㅠㅠ","ㅠㅠㅠㅠ","ㅠㅠㅠㅠㅠ","ㅠㅠㅠㅠㅠㅠ","ㅠㅠㅠㅠㅠㅠㅠ","ㅜ","ㅜㅜ","ㅜㅜㅜ","ㅜㅜㅜㅜ","ㅜㅜㅜㅜㅜ","ㅜㅜㅜㅜㅜㅜ","ㅜㅜㅜㅜㅜㅜㅜ","ㅜㅜㅜㅜㅜㅜㅜㅜ","ㅠㅜ","ㅜㅠ","뉴뉴","슬퍼","개슬퍼"};
	final Stack<String> reservedCryWord = new Stack<String>();
	
	final String[] reservedSurprised = {"헉","헐키","헐퀴","허걱","헐","허거덩","허거"};
	final Stack<String> reservedSurprisedWord = new Stack<String>();
	
	final String[] reservedShake = {"ㄷ","ㄷㄷ","ㄷㄷㄷ","ㄷㄷㄷㄷ","ㄷㄷㄷㄷㄷ","ㄷㄷㄷㄷㄷㄷ","ㄷㄷㄷㄷㄷㄷㄷ","ㄷㄷㄷㄷㄷㄷㄷㄷ","ㅎㄷㄷ","ㅎㄷ","덜","덜덜","후덜","후덜덜"};
	final Stack<String> reservedShakeWord = new Stack<String>();
	
	final String[] reservedO = {"오윤식","윤식","오윤식대리","오윤식님","윤식대리","윤식님","잘자"};
	final Stack<String> reservedOWord = new Stack<String>();
	
	
	
	public  ReservedWord(){
		for(int i=0; i<reservedLaugh.length; i++){
			reservedLaughWord.push(reservedLaugh[i]);
		}
		
		for(int i=0; i<reservedSmile.length; i++){
			reservedSmileWord.push(reservedSmile[i]);
		}
		
		for(int i=0; i<reservedSurprised.length; i++){
			reservedSurprisedWord.push(reservedSurprised[i]);
		}
		
		for(int i=0; i<reservedCry.length; i++){
			reservedCryWord.push(reservedCry[i]);
		}
		
		for(int i=0; i<reservedShake.length; i++){
			reservedShakeWord.push(reservedShake[i]);
		}
		
		for(int i=0; i<reservedO.length; i++){
			reservedOWord.push(reservedO[i]);
		}
	}
	
	public boolean checkReservedLaughWord(String msg){
		return reservedLaughWord.contains(msg);
	}
	public boolean checkReservedSmileWord(String msg){
		return reservedSmileWord.contains(msg);
	}
	public boolean checkReservedCryWord(String msg){
		return reservedCryWord.contains(msg);
	}
	public boolean checkReservedSurprisedWord(String msg){
		return reservedSurprisedWord.contains(msg);
	}
	public boolean checkReservedShakeWord(String msg){
		return reservedShakeWord.contains(msg);
	}
	public boolean checkReservedOWord(String msg){
		return reservedOWord.contains(msg);
	}
	
	public String checkReservedWord(String msg){
		String result = msg;		
		if(reservedLaughWord.contains(msg)) result = "laugh";
		if(reservedSmileWord.contains(msg)) result = "smile";
		if(reservedCryWord.contains(msg)) result = "cry";	
		if(reservedShakeWord.contains(msg)) result = "shake";
		if(reservedSurprisedWord.contains(msg)) result = "surprised";		
		return result;
	}
	
}
