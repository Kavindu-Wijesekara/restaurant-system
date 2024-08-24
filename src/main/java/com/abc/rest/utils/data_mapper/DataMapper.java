package com.abc.rest.utils.data_mapper;

import javax.servlet.http.HttpServletRequest;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Map;

public class DataMapper {

    private static DataMapper dataMapper;

    public static DataMapper getDataMapper() {
        if (dataMapper == null) {
            dataMapper = new DataMapper();
        }
        return dataMapper;
    }

    public String mapData(HttpServletRequest request) {
        Map<String, String> requestData = new HashMap<>();
        Enumeration<String> parameterNames = request.getParameterNames();

        while (parameterNames.hasMoreElements()) {
            String paramName = parameterNames.nextElement();
            requestData.put(paramName, request.getParameter(paramName));
        }

        return new com.google.gson.Gson().toJson(requestData);
    }
}
