import React from 'react';
import { Theme, createStyles, makeStyles } from '@material-ui/core/styles';
import GridList from '@material-ui/core/GridList';
import GridListTile from '@material-ui/core/GridListTile';
import GridListTileBar from '@material-ui/core/GridListTileBar';
import ListSubheader from '@material-ui/core/ListSubheader';
import IconButton from '@material-ui/core/IconButton';
import InfoIcon from '@material-ui/icons/Info';
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

    return (
        <div className={classes.root}>
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
                                <IconButton aria-label={`info about ${apod.title}`} className={classes.icon}>
                                    <InfoIcon />
                                </IconButton>
                            }
                        />
                    </GridListTile>
                ))}
            </GridList>
        </div>
    );
}
