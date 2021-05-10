package sms;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.List;

import org.apache.http.HttpResponse;
import org.apache.http.NameValuePair;
import org.apache.http.client.HttpClient;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.message.BasicNameValuePair;
import org.springframework.stereotype.Component;

@Component
public class SendSMS {

	public void send(String msg) throws Exception {
		String url1 = "http://www.banding.co.kr/sms/smssend.jsp";

		List<NameValuePair> urlParameters = new ArrayList<NameValuePair>();
		urlParameters.add(new BasicNameValuePair("action", "go"));
		urlParameters.add(new BasicNameValuePair("smsType", "S"));
		urlParameters.add(new BasicNameValuePair("msg", msg));
		urlParameters.add(new BasicNameValuePair("rphone", "01046162977"));
		urlParameters.add(new BasicNameValuePair("sphone1", "070"));
		urlParameters.add(new BasicNameValuePair("sphone2", "5055"));
		urlParameters.add(new BasicNameValuePair("sphone3", "5342"));
		this.sendPost(url1, urlParameters);
	}

	// HTTP POST request
	private void sendPost(String url, List<NameValuePair> urlParameters) throws Exception {

		HttpClient client = new DefaultHttpClient();
		HttpPost post = new HttpPost(url);

		// add header
		post.setHeader("Content-type", "application/x-www-form-urlencoded");
		post.setEntity(new UrlEncodedFormEntity(urlParameters, "utf-8"));

		HttpResponse response = client.execute(post);
		// System.out.println("\nSending 'POST' request to URL : " + url);
		// System.out.println("Post parameters : " + post.getEntity());
		// System.out.println("Response Code : " +
		// response.getStatusLine().getStatusCode());

		BufferedReader rd = new BufferedReader(new InputStreamReader(response.getEntity().getContent(), "UTF-8"));

		StringBuffer result = new StringBuffer();
		String line = "";
		while ((line = rd.readLine()) != null) {
			result.append(line);
		}

		System.out.println(result.toString());

	}

}
