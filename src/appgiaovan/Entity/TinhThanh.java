/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package appgiaovan.Entity;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

@JsonIgnoreProperties(ignoreUnknown = true)
public class TinhThanh {

    public String code;
    public String name;
      public String parent_code; 

    public TinhThanh() {

    }
    
    public TinhThanh(String code, String name){
        this.code = code;
        this.name = name;
    }

    @Override
    public String toString() {
        return this.name;
    }

}
