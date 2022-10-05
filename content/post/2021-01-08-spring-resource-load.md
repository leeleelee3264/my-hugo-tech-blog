+++
title = "(en) Load static/dynamic resource Spring jar"
date = "2021-01-08"
description = "Spring jar에서 static/dynamic 리소스를 로드하는 방법을 다룬다."
tags = ["Backend"]
+++



<br>
<br> 

> Spring jar에서 static/dynamic 리소스를 로드하는 방법을 다룬다

<br> 

**Index**
1. How to load static/dynamic resource in Spring jar
2. Fun fact 

<br> 

# How to load static/dynamic resource in Spring jar 


### First case: Static resource
Roughly 4 months age, I was assigned to make function with excel. It was like this. _I had made a template excel in advance_ and my colleagues downloaded it and filled it. After that, I read it and inserted data to database.

#### Point of static resource 
- I have to make and save file before deploying. (making jar file)
- Never got changed, because it's a template!
- Can saved in jar static dir `(inside of jar)`

<br> 

### Second case: Dynamic resource
And this week, I was assigned new function also related with excel. I have to make a excel file which is analysis purpose and let it get downloaded. Sadly, data in the excel file get changed frequently.
This function has to make excel every request. 

#### Point of dynamic resource 
- I have to make and save file on run time.
- Always freshly made!
- jar already closed, can saved in other dir `(outside of jar)`


<br> 

Both are about downloading excel file in server. But there is a huge difference.

<br> 


### How to load then? 


1. Use `ClassPathResource` and relative path to get file `static resource in jar`
2. Use `ResourceLoader` and absolute path to get file `dynamic resource outside of jar`

Take a look at [[Classpath resource not found when running as jar]](https://stackoverflow.com/questions/25869428/classpath-resource-not-found-when-running-as-jar).

<br> 

> ClassPathResource for static resource

{{< highlight java  "linenos=true,hl_inline=false" >}}

private final MediaType excelType = MediaType.parseMediaType("application/vnd.ms-excel");

String EXCEL_STATIC_PATH = "static/excel/"

@GetMapping("/{data}/template/download")
@ResponseBody
public ResponseEntity<Resource> getTemplate(
    @PathVariable(name = "data") String data
) {
    String requestData = Util.nvl(data);
    String fileName = "";

    if (requestData.equals("vts")) {
        fileName = "vts_template.xlsx"; 
    }

    try {
        ClassPathResource classPathResource = new ClassPathResource(EXCEL_STATIC_PATH + fileName);

        return ResponseEntity.ok()
            .header(HttpHeaders.CONTENT_DISPOSITION, "attachment;filename=" + classPathResource.getFilename())
            .header(HttpHeaders.CONTENT_LENGTH, String.valueOf(classPathResource.contentLength()))
            .header(HttpHeaders.CONTENT_TYPE, String.valueOf(excelType))
            .body(classPathResource);

    } catch (Exception e) {
        log.error(e.getMessage(), e);
        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
    }
}
{{< /highlight >}}


<br> 

> ResourceLoader for dynamic resource 

{{< highlight java  "linenos=true,hl_inline=false" >}}

@Autowired
private ResourceLoader resourceLoader;
      
@Value("${property.excel.dir}")
private String EXCEL_GENERATED_DIR; 

@GetMapping(value = "/{type}/count/download")
@ResponseBody
public ResponseEntity<Resource> testGetValueFromExcel(
    @PathVariable(name = "type") String type
) {
    
    String ttsType = validDnxTts.get(type);

    String fileName = excelService.makeVtsMessageExcel(ttsType, type, EXCEL_GENERATED_DIR);
    Resource resultResource;
    
    try {
        // This name will be showed up to client
        String fullFile = new StringBuilder().append(EXCEL_SEVER_HOST).append("_").append(fileName).toString();
    
        resultResource = resourceLoader.getResource("file:" + EXCEL_GENERATED_DIR + fileName);
    
        return ResponseEntity.ok()
            .header(HttpHeaders.CONTENT_DISPOSITION, "attachment;filename=" + fullFile)
            .header(HttpHeaders.CONTENT_LENGTH, String.valueOf(resultResource.contentLength()))
            .header(HttpHeaders.CONTENT_TYPE, String.valueOf(excelType))
            .body(resultResource);

    } catch (Exception e) {
        log.error(e.getMessage(), e);
        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
    }
}
{{< /highlight >}}



<br> 

# Fun fact

### File Path in Windows and Linux 
File storage path grammar is different, so had better write down both on properties file.

<br> 

> Windows file path 

{{< highlight yaml  "linenos=true,hl_inline=false" >}}

property.excel.dir=\\C:\\Temp\\Admin\\
{{< /highlight >}}
 
<br> 

> Linux file path 

{{< highlight yaml  "linenos=true,hl_inline=false" >}}

property.excel.dir=/opt/temp/
{{< /highlight >}}

<br> 

### Accident with `/`

I accidentally attached `/` in  resourceLoader.getResource("file:" + EXCEL_GENERATED_DIR + fileName);

So in Linux, it looks like `file://opt/temp/`. In this case, I saw _java.net.UnknownHostException: socialweb-analytics.lcloud.com: Name or service not known exception_ lol. Server thinks it's host. 