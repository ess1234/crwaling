package peep;

import java.io.IOException;

import org.apache.commons.httpclient.HttpClient;
import org.apache.commons.httpclient.HttpException;
import org.apache.commons.httpclient.HttpStatus;
import org.apache.commons.httpclient.methods.GetMethod;
import org.springframework.scheduling.annotation.Scheduled;

import sms.SendSMS;

public class Crawling {
	
	// 초 분 시 일 월 년
	// @Scheduled(cron = "0 0/10 * * * *")
	public void checkLecture() throws Exception {

		String[] urls = { "http://sports.isdc.co.kr/lecture/detail/index/SIMC01/2001/00161/I000310",
				"http://sports.isdc.co.kr/lecture/detail/index/SIMC01/2001/00164/I000314",
				"http://sports.isdc.co.kr/lecture/detail/index/SIMC01/2001/00163/I000310",
				"http://sports.isdc.co.kr/lecture/detail/index/SIMC01/2001/00166/I000314" };

		for (int i = 0; i < urls.length; i++) {
			String url = urls[i];
			String html = "";

			try {
				html = this.getHtml(url);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
				continue;
			}

			String avail = "";

			try {
				avail = this.findPattern(html, "<span class=\"color_red bold\">", "</span>");
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
				continue;
			}
			
			System.out.println(url +" :: "+avail);
			
			if(!avail.equals("마감")) {
				SendSMS sms = new SendSMS();
				sms.send(url +" :: "+avail);
			}
		}
	}

	public String getHtml(String url) throws HttpException, IOException {
		String html = "";
		HttpClient httpClient = new HttpClient();
		GetMethod httpMethod = new GetMethod(url);

		int status = httpClient.executeMethod(httpMethod);
		if (status == HttpStatus.SC_OK) {
			html = httpMethod.getResponseBodyAsString();
		}
		return html;
	}
	
	public String findPattern(String argTarget, String argPattern1, String argPattern2) throws Exception {
		String val = (argTarget.split(argPattern1)[1]).split(argPattern2)[0];
		val = val.replaceAll("<(/)?([a-zA-Z]*)(\\s[a-zA-Z]*=[^>]*)?(\\s)*(/)?>", "");
		return val.trim();
	}

}
