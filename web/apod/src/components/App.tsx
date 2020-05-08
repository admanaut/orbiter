import React from 'react';
import { Theme, createStyles, makeStyles } from '@material-ui/core/styles';
import GridList from '@material-ui/core/GridList';
import GridListTile from '@material-ui/core/GridListTile';
import GridListTileBar from '@material-ui/core/GridListTileBar';
import ListSubheader from '@material-ui/core/ListSubheader';
import IconButton from '@material-ui/core/IconButton';
import InfoIcon from '@material-ui/icons/Info';
import CloseIcon from '@material-ui/icons/Close';
import Tooltip from '@material-ui/core/Tooltip';
import Dialog from '@material-ui/core/Dialog';
import Grid from '@material-ui/core/Grid';
import { apodData } from '@/resources/apod';

interface APOD {
    url: string,
    title: string,
    media_type: string
    hdurl?: string,
    explanation: string,
    date: string,
    service_version: string,
    copyright?: string
}

const useStyles = makeStyles((theme: Theme) =>
    createStyles({
        root: {
            display: 'flex',
            flexWrap: 'wrap',
            justifyContent: 'space-around',
            overflow: 'hidden',
            backgroundColor: theme.palette.background.paper,
        },
        gridList: {
            width: 750,
            height: 450,
        },
        icon: {
            color: 'rgba(255, 255, 255, 0.54)',
        }
    }),
);

export function App() {
    const classes = useStyles();
    const [selectedAPOD, setselectedAPOD] = React.useState(null);

    const handleClickOpen = (apod: APOD) => {
        setselectedAPOD(apod);
    };

    const handleClose = () => {
        setselectedAPOD(null);
    };

    return (
        <div className={classes.root}>
            {selectedAPOD ?
                (<Dialog fullScreen open={selectedAPOD ? true : false} onClose={handleClose}>
                    <IconButton edge="start" color="inherit" onClick={handleClose} aria-label="close">
                        <CloseIcon />
                    </IconButton>
                    <p>{selectedAPOD.explanation}</p>
                    {(() => {
                        console.log(selectedAPOD.media_type);
                        switch (selectedAPOD.media_type) {
                            case "video": return (
                                <iframe width="560" height="315" src={selectedAPOD.url}></iframe>
                            );
                            case "image": return (
                                <img src={selectedAPOD.url} alt={selectedAPOD.title} />
                            );
                        }
                    }
                    )()}
                </Dialog>)
                : <></>
            }
            <GridList cellHeight={180} className={classes.gridList} cols={3}>
                <GridListTile key="Subheader" cols={3} style={{ height: 'auto' }}>
                    <ListSubheader component="div">APOD</ListSubheader>
                </GridListTile>
                {apodData.map((apod: APOD) => (
                    <GridListTile key={apod.url}>
                        <img src={apod.url} alt={apod.title} />
                        <GridListTileBar
                            title={apod.title}
                            subtitle={<span>{apod.date}</span>}
                            actionIcon={
                                <Tooltip title="See more">
                                    <IconButton aria-label={`info about ${apod.title}`} className={classes.icon} onClick={() => handleClickOpen(apod)}>
                                        <InfoIcon />
                                    </IconButton>
                                </Tooltip>
                            }
                        />
                    </GridListTile>
                ))}
            </GridList>
        </div>
    );
}
