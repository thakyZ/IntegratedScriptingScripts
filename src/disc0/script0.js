const stringMatchesRegex = idContext.ops.stringMatchesRegex;
const itemstackTags = idContext.ops.itemstackTags;
const stringItemsByTag = idContext.ops.stringItemsByTag;

const rawItemsTag  = "forge:raw_materials";
const rawBlocksTag = "forge:storage_blocks";
const rawBlocksReg = "^forge:storage_blocks/raw_.+$";

const rawItemsList      = stringItemsByTag(rawItemsTag);
const rawBlocksList     = stringItemsByTag(rawBlocksTag);

const rawBlocksFiltered = rawBlocksList.filter(item => {
  const tags = itemstackTags(item);
  const filteredTags = tags.filter(tag => {
    return /^forge:storage_blocks\/raw_.+$/.test(tag);
  });
  return filteredTags.length > 0;
});

const joinedList = rawItemsList.concat(rawBlocksFiltered);

/**
 * Entrypoint of this script.
 * For use with a Occultism crusher mob ore processor.
 * @param {boolean} toggle The state of a redstone signal.
 * @returns {Array<ValueItemstack>} Two different list of items depending on redstone state.
 */
const run = (toggle) => toggle ? joinedList : rawItemsList;
