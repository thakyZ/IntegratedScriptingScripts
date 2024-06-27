const entityIsPlayer = idContext.ops.entityIsPlayer;

/**
 * Entrypoint for this script.
 * For use with a Occultism crusher mob ore processor.
 * @param {Array<ValueEntity>} players List of players in the world entity interface.
 * @param {Array<ValueEntity>} entities List of entities in the world entity interface.
 * @param {boolean} state The global state of the mechanism.
 * @returns {boolean} Returns a redstone state of
 */
const run = (players, entities, state) => {
  return (state === true &&
          players.length === 0 &&
          entities.filter(x => entityIsPlayer(x)).length === 0 &&
          entities.length === 0);
}
