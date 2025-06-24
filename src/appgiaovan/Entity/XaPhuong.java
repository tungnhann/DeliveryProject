
package appgiaovan.Entity;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

@JsonIgnoreProperties(ignoreUnknown = true)
public class XaPhuong {

    public String code;
    public String name;
      public String parent_code; 

    public XaPhuong() {

    }
    
    public XaPhuong(String code, String name){
        this.code = code;
        this.name = name;
    }

    @Override
    public String toString() {
        return this.name;
    }

}
