import React from 'react';
import Dialog from '@material-ui/core/Dialog';
import IconButton from '@material-ui/core/IconButton';
import CloseIcon from '@material-ui/icons/Close';
import { APOD, MediaType } from '@/model/APOD';

interface APODDialogProps {
    apod: APOD | null,
    onClose: (() => void)
}

export function APODDialog(props: APODDialogProps): JSX.Element {
    const apod = props.apod;
    const open = apod !== null;

    return open ?
        (<Dialog fullScreen open={open} onClose={props.onClose}>
            <IconButton edge="start" color="inherit" onClick={props.onClose} aria-label="close">
                <CloseIcon />
            </IconButton>
            <p>{apod.explanation}</p>
            { apod.copyright ? (<p>Copyright: {apod.copyright}</p>) : <></>}
            {(() => {
                switch (apod.media_type) {
                    case MediaType.Video: return (
                        <iframe width="560" height="315" src={apod.url}></iframe>
                    );
                    case MediaType.Image: return (
                        <img src={ apod.hdurl ? apod.hdurl : apod.url} alt={apod.title} />
                    );
                }
            }
            )()}
        </Dialog>)
        : <></>
};