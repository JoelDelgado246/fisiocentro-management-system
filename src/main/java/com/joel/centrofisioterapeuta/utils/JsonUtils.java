package com.joel.centrofisioterapeuta.utils;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonPrimitive;
import com.google.gson.JsonSerializer;

import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.Date;

/**
 * Utilidad para serialización JSON con soporte para fechas y horas
 */
public class JsonUtils {

    private static final SimpleDateFormat DATE_FORMAT =
            new SimpleDateFormat("yyyy-MM-dd");

    private static final SimpleDateFormat DATETIME_FORMAT =
            new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

    private static final DateTimeFormatter LOCAL_DATE_FORMATTER =
            DateTimeFormatter.ofPattern("yyyy-MM-dd");

    private static final DateTimeFormatter LOCAL_TIME_FORMATTER =
            DateTimeFormatter.ofPattern("HH:mm:ss");

    private static final DateTimeFormatter LOCAL_DATETIME_FORMATTER =
            DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

     private static final Gson GSON = new GsonBuilder()

            // java.util.Date
            .registerTypeAdapter(Date.class,
                    (JsonSerializer<Date>) (date, type, context) ->
                            date == null
                                    ? null
                                    : new JsonPrimitive(DATE_FORMAT.format(date))
            )

            // java.time.LocalDate
            .registerTypeAdapter(LocalDate.class,
                    (JsonSerializer<LocalDate>) (date, type, context) ->
                            date == null
                                    ? null
                                    : new JsonPrimitive(date.format(LOCAL_DATE_FORMATTER))
            )

            // java.time.LocalTime
            .registerTypeAdapter(LocalTime.class,
                    (JsonSerializer<LocalTime>) (time, type, context) ->
                            time == null
                                    ? null
                                    : new JsonPrimitive(time.format(LOCAL_TIME_FORMATTER))
            )

            // java.time.LocalDateTime
            .registerTypeAdapter(LocalDateTime.class,
                    (JsonSerializer<LocalDateTime>) (dateTime, type, context) ->
                            dateTime == null
                                    ? null
                                    : new JsonPrimitive(dateTime.format(LOCAL_DATETIME_FORMATTER))
            )

            .create();

    private JsonUtils() {

    }

    /**
     * Convierte un objeto a JSON
     */
    public static String toJson(Object object) {
        return GSON.toJson(object);
    }

    /**
     * Convierte JSON a objeto
     */
    public static <T> T fromJson(String json, Class<T> classOfT) {
        return GSON.fromJson(json, classOfT);
    }
}
