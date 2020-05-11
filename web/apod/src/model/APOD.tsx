import { apodData } from "../resources/apod";

export enum MediaType {
    Video = 'video',
    Image = 'image'
}

export interface APOD {
    url: string,
    title: string,
    media_type: MediaType,
    hdurl?: string,
    explanation: string,
    date: string,
    service_version: string,
    copyright?: string
}

export function parseAPOD(jsonString: string): APOD {
    return JSON.parse(jsonString);
}