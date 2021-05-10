package utils;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.Properties;

import org.springframework.stereotype.Component;

@Component
public class Util {
	
	private Properties proper;

	public void PropertiesRed(String filePath) {

		this.proper = new Properties();
		try {
			// 한글이 깨지는 문제 때문에 인코딩을 지정해서 읽을수 있도록 함.
			this.proper.load(new BufferedReader(new InputStreamReader(new FileInputStream(filePath), "UTF-8")));
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	public String read(String key) {
		return proper.getProperty(key);
	}
	
	public String readDeployInfo(String key){
		String path = this.getClass().getResource("/").getPath(); // 현재 클래스의 절대 경로를 가져온다.
	    PropertiesRed(path+"deployInfo.properties");
	    return read(key);
	}
	
	public void createFile(String filename, String result){
		String realPath = this.readDeployInfo("FILE_PATH");
		File file = new File(realPath+filename);
		try {
			BufferedWriter out = new BufferedWriter(new FileWriter(file));
			out.write(result);
			out.flush();
			out.close();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

}
